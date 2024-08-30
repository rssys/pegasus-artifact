#include <cstdio>
#include <ctime>
#include <cstdlib>
#include <cerrno>
#include <csignal>
#include <cstring>
#include <unistd.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <netinet/in.h>

static uint64_t time_nanosec() {
    struct timespec t;
    clock_gettime(CLOCK_MONOTONIC, &t);
    return t.tv_sec * 1000000000ull + t.tv_nsec;
}

void run_server() {
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket");
        exit(1);
    }
    int val = 1;
    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
    struct sockaddr_in addr {};
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(8000);

    if (bind(sockfd, (struct sockaddr *)&addr, sizeof(addr)) < 0 ){
        perror("bind\n");
        exit(1);
    }

    listen(sockfd, 16);
    struct sockaddr_in caddr;
    socklen_t len = sizeof(caddr);
    int fd = accept(sockfd, (struct sockaddr *)&caddr, &len);
    if (fd < 0) {
        perror("accept\n");
        exit(1);
    }
    char buf[32];
    for (int i = 0; i < 100000; ++i) {
        read(fd, buf, 1);
        write(fd, buf, 1);
    }
}

void run_client(const char *ip) {
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket");
        exit(1);
    }
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    inet_pton(AF_INET, ip, &addr.sin_addr);
    addr.sin_port = htons(8000);
    if (connect(sockfd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("connect");
        exit(1);
    }
    char buf[32];
    uint64_t t1 = time_nanosec();
    for (int i = 0; i < 100000; ++i) {
        write(sockfd, buf, 1);
        read(sockfd, buf, 1);
    }
    uint64_t t2 = time_nanosec();
    printf("time: %lu\n", (t2 - t1) / 100000);
}

int main(int argc, char **argv) {
    if (strcmp(argv[1], "server") == 0) {
        run_server();
    } else {
        run_client(argv[1]);
    }
    return 0;
}
