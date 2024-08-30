#include <thread>
#include <condition_variable>
#include <functional>
#include <mutex>
#include <ctime>
#include <cstdio>
#include <csignal>
#include <cinttypes>
#include <cassert>
#include <unistd.h>
#include <fcntl.h>
#include <sys/syscall.h>
#include <sys/poll.h>
#include <sys/epoll.h>
#include <sys/mman.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <ucontext.h>

inline static uint64_t time_nanosec(clockid_t cid = CLOCK_MONOTONIC) {
    struct timespec t;
    clock_gettime(cid, &t);
    return t.tv_sec * 1000000000ull + t.tv_nsec;
}

int main(int argc, char **argv) {
    if (argc == 2 && atoi(argv[1]) == 1) {
        cpu_set_t set;
        CPU_ZERO(&set);
        CPU_SET(0, &set);
        pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &set);
    }
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    assert(sockfd != -1);
    int val = 1;
    setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
    struct sockaddr_in addr {};
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(9000);

    assert(bind(sockfd, (struct sockaddr *)&addr, sizeof(addr)) == 0);

    listen(sockfd, 16);
    struct sockaddr_in caddr;
    socklen_t len = sizeof(caddr);
    int fd = accept(sockfd, (struct sockaddr *)&caddr, &len);
    assert(fd != -1);
    char buf[32];
    for (int i = 0; i < 1000000; ++i) {
        assert(read(fd, buf, 1) == 1);
        assert(write(fd, buf, 1) == 1);
    }
    return 0;
}
