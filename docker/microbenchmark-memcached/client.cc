#include <ctime>
#include <cstdio>
#include <cinttypes>
#include <cassert>
#include <unistd.h>
#include <pthread.h>
#include <libmemcached/memcached.h>

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
    sleep(1);
    memcached_st *m = memcached_create(nullptr);
    memcached_return res;
    memcached_server_st *servers = memcached_server_list_append(NULL, "127.0.0.1", 11211, &res);
    assert(res == MEMCACHED_SUCCESS);
    assert(memcached_server_push(m, servers) == MEMCACHED_SUCCESS);
    uint64_t t1 = time_nanosec();
    for (int i = 0; i < 1000000; ++i) {
        assert(memcached_set(m, "k", 1, "v", 1, 0, 0) == MEMCACHED_SUCCESS);
    }
    uint64_t t2 = time_nanosec();
    printf("%lu\n", (t2 - t1) / 1000000);
    return 0;
}