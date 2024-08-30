#include <ctime>
#include <cstdio>
#include <cassert>
#include <cstring>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <demi/libos.h>
#include <demi/sga.h>
#include <demi/wait.h>

static uint64_t time_nanosec() {
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec * 1000000000ull + t.tv_nsec;
}
static int accept_wait(int qd)
{
    demi_qtoken_t qt = -1;
    demi_qresult_t qr = {};
    assert(demi_accept(&qt, qd) == 0);
    assert(demi_wait(&qr, qt, NULL) == 0);
    assert(qr.qr_opcode == DEMI_OPC_ACCEPT);
    return qr.qr_value.ares.qd;
}
static void connect_wait(int qd, const struct sockaddr_in *saddr)
{
    demi_qtoken_t qt = -1;
    demi_qresult_t qr = {};
    assert(demi_connect(&qt, qd, (const struct sockaddr *)saddr, sizeof(struct sockaddr_in)) == 0);
    assert(demi_wait(&qr, qt, NULL) == 0);
    assert(qr.qr_opcode == DEMI_OPC_CONNECT);
}

static void push_wait(int qd, demi_sgarray_t *sga, demi_qresult_t *qr)
{
    demi_qtoken_t qt = -1;
    assert(demi_push(&qt, qd, sga) == 0);
    assert(demi_wait(qr, qt, NULL) == 0);
    assert(qr->qr_opcode == DEMI_OPC_PUSH);
}

static void pop_wait(int qd, demi_qresult_t *qr)
{
    demi_qtoken_t qt = -1;
    assert(demi_pop(&qt, qd) == 0);
    assert(demi_wait(qr, qt, NULL) == 0);
    assert(qr->qr_opcode == DEMI_OPC_POP);
    assert(qr->qr_value.sga.sga_segs != 0);
}

static void server(int argc, char *const argv[], struct sockaddr_in *local)
{
    int qd = -1;
    int nbytes = 0;
    int sockqd = -1;

    /* Initialize demikernel */
    assert(demi_init(0, NULL) == 0);

    /* Setup local socket. */
    assert(demi_socket(&sockqd, AF_INET, SOCK_STREAM, 0) == 0);
    assert(demi_bind(sockqd, (const struct sockaddr *)local, sizeof(struct sockaddr_in)) == 0);
    assert(demi_listen(sockqd, 16) == 0);

    /* Accept client . */
    qd = accept_wait(sockqd);

    printf("accepted\n");

    /* Run. */
    for (int i = 0; i < 100000; ++i)
    {
        demi_qresult_t qr {};
        demi_sgarray_t sga {};

        /* Pop scatter-gather array. */
        pop_wait(qd, &qr);

        /* Extract received scatter-gather array. */
        memcpy(&sga, &qr.qr_value.sga, sizeof(demi_sgarray_t));

        nbytes += sga.sga_segs[0].sgaseg_len;

        /* Push scatter-gather array. */
        push_wait(qd, &sga, &qr);

        /* Release received scatter-gather array. */
        assert(demi_sgafree(&sga) == 0);
    }
}

static void client(int argc, char *const argv[], const struct sockaddr_in *remote)
{
    int nbytes = 0;
    int sockqd = -1;

    /* Initialize demikernel */
    assert(demi_init(0, NULL) == 0);

    /* Setup socket. */
    assert(demi_socket(&sockqd, AF_INET, SOCK_STREAM, 0) == 0);

    /* Connect to server. */
    connect_wait(sockqd, remote);

    printf("connected\n");

    /* Run. */
    demi_sgarray_t sga = demi_sgaalloc(1);
    assert(sga.sga_segs != 0);
    uint64_t t1 = time_nanosec();
    for (int i = 0; i < 100000; i++)
    {
        demi_qresult_t qr {};

        /* Push scatter-gather array. */
        push_wait(sockqd, &sga, &qr);

        /* Pop data scatter-gather array. */
        memset(&qr, 0, sizeof(demi_qresult_t));
        pop_wait(sockqd, &qr);

        /* Release received scatter-gather array. */
        assert(demi_sgafree(&qr.qr_value.sga) == 0);
    }
    uint64_t t2 = time_nanosec();
    printf("time: %lu\n", (t2 - t1) / 100000);
}

void build_sockaddr(const char *const ip_str, const char *const port_str, struct sockaddr_in *const addr)
{
    int port = -1;

    sscanf(port_str, "%d", &port);
    addr->sin_family = AF_INET;
    addr->sin_port = htons(port);
    assert(inet_pton(AF_INET, ip_str, &addr->sin_addr) == 1);
}

int main(int argc, char *const argv[])
{
    if (argc >= 4) {

        struct sockaddr_in saddr = {0};

        /* Build addresses.*/
        build_sockaddr(argv[2], argv[3], &saddr);

        /* Run. */
        if (!strcmp(argv[1], "--server"))
            server(argc, argv, &saddr);
        else if (!strcmp(argv[1], "--client"))
            client(argc, argv, &saddr);

        return 0;
    }

    return 0;
}


