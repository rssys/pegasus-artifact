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
    sleep(5);
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    assert(sockfd != -1);
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    addr.sin_port = htons(9000);
    assert(connect(sockfd, (struct sockaddr *)&addr, sizeof(addr)) == 0);
    char buf[32] = "A";
    uint64_t t1 = time_nanosec();
    for (int i = 0; i < 1000000; ++i) {
        assert(write(sockfd, buf, 1) == 1);
        assert(read(sockfd, buf, 1) == 1);
    }
    uint64_t t2 = time_nanosec();
    printf("%lu\n", (t2 - t1) / 1000000);
    return 0;
}
