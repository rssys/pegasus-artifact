#include <ctime>
#include <cstdio>
#include <cinttypes>
#include <cassert>
#include <unistd.h>
#include <hiredis/hiredis.h>
#include <pthread.h>

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
    redisContext *conn = redisConnect("127.0.0.1", 6379);
    assert(conn);
    uint64_t t1 = time_nanosec();
    for (int i = 0; i < 1000000; ++i) {
        redisReply *reply = (redisReply *)redisCommand(conn, "SET %s %s", "k", "v");
        assert(reply);
        freeReplyObject(reply);
    }
    uint64_t t2 = time_nanosec();
    printf("%lu\n", (t2 - t1) / 1000000);
    //redisCommand(conn, "SHUTDOWN");
    redisFree(conn);
    return 0;
}
