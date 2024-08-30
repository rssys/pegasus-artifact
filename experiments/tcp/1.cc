#include <cstdio>
#include <ctime>
#include <cstdlib>
#include <cstring>
#include <cerrno>
#include <unistd.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/epoll.h>
#include <sys/ioctl.h>
#include <fcntl.h>

#include "ff_config.h"
#include "ff_api.h"
#include "ff_epoll.h"

int sockfd;
int fd;
const char *ip;
int iter;
bool established;

static uint64_t time_nanosec() {
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec * 1000000000ull + t.tv_nsec;
}

int server_loop(void *) {
    if (!established) {
        struct pollfd fds;
        fds.fd = sockfd;
        fds.events = POLLIN;
        if (ff_poll(&fds, 1, 0) == 0) {
            return 0;
        }
        fd = ff_accept(sockfd, NULL, NULL);
        established = true;
    }

    struct pollfd fds;
    fds.fd = fd;
    fds.events = POLLIN;
    if (ff_poll(&fds, 1, 0) == 0) {
        return 0;
    }

    char buf[32];
    ff_read(fd, buf, 1);
    ff_write(fd, buf, 1);
    
    if (++iter == 100000) {
        printf("done\n");
    }
    return 0;
}

void run_server() {
    sockfd = ff_socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket");
        exit(1);
    }

    int on = 1;
    ff_ioctl(sockfd, FIONBIO, &on);

    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(8000);

    if (ff_bind(sockfd, (struct linux_sockaddr *)&addr, sizeof(addr)) < 0 ){
        perror("bind");
        exit(1);
    }

    ff_listen(sockfd, 2);

    ff_run(server_loop, NULL);
}

uint64_t t1, t2;

int client_loop(void *) {
    char buf[32];
    if (!established) {
        struct pollfd fds;
        fds.fd = sockfd;
        fds.events = POLLOUT;
        if (ff_poll(&fds, 1, 0) == 0) {
            return 0;
        }
        established = true;
        t1 = time_nanosec();
        ff_write(sockfd, buf, 1);
    }

    struct pollfd fds;
    fds.fd = sockfd;
    fds.events = POLLIN;
    if (ff_poll(&fds, 1, 0) == 0) {
        return 0;
    }

    ff_read(sockfd, buf, 1);
    ff_write(sockfd, buf, 1);
    
    if (++iter == 100000) {
        t2 = time_nanosec();
        printf("time: %lu\n", (t2 - t1) / 100000);
    }
    return 0;
}

void run_client() {
    sockfd = ff_socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket");
        exit(1);
    }

    int on = 1;
    ff_ioctl(sockfd, FIONBIO, &on);

    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    inet_pton(AF_INET, ip, &addr.sin_addr);
    addr.sin_port = htons(8000);
    ff_connect(sockfd, (struct linux_sockaddr *)&addr, sizeof(addr));
    char buf[32];

    ff_run(client_loop, NULL);
}

int main(int argc, char **argv) {
    ff_init(argc - 1, argv + 1);
    if (strcmp(argv[1], "server") == 0) {
        run_server();
    } else {
        ip = argv[1];
        run_client();
    }
    return 0;
}

