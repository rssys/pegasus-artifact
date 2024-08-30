#include <condition_variable>
#include <thread>
#include <cstdio>
#include <ctime>
#include <cassert>
#include <cstdlib>
#include <climits>
#include <unistd.h>
#include <sys/syscall.h>
#include <linux/futex.h>
#include <x86intrin.h>
#include <sys/auxv.h>

static bool use_pegasus;

inline long pegasus_syscall(int sysno, long arg1 = 0, long arg2 = 0, long arg3 = 0, long arg4 = 0, long arg5 = 0, long arg6 = 0) {
    register long rax asm ("rax") = 0;
    register long rdi asm ("rdi") = arg1;
    register long rsi asm ("rsi") = arg2;
    register long rdx asm ("rdx") = arg3;
    register long r10 asm ("r10") = arg4;
    register long r8  asm ("r8") = arg5;
    register long r9  asm ("r9") = arg6;
    register long rcx asm ("rcx") = sysno;
    asm volatile (
        "callq *%%gs:8\n"
        : "+r" (rax)
        : "r" (rdi), "r" (rsi), "r" (rdx), "r" (rcx), "r" (r8), "r" (r9), "r" (r10)
        : "memory", "r11", "r12", "r13", "r14", "r15"
    );
    return rax;
}

template <typename... T>
inline long auto_syscall(int sysno, T... args) {
    if (!use_pegasus) {
        return syscall(sysno, args...);
    } else {
        return pegasus_syscall(sysno, ((long)args)...);
    }
}

uint64_t t1, t2;
uint64_t total_t;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
int counter;
constexpr int N = 1000000;
constexpr int WarmUp = 1000;
double factor;

static void *cv_thread1(void *data) {
    sleep(1);
    pthread_mutex_lock(&mutex);
    for (int i = 0; i < N + WarmUp; ++i) {
        while (counter % 2) {
            pthread_cond_wait(&cond, &mutex);
        }
        ++counter;
        t1 = __rdtsc();
        pthread_mutex_unlock(&mutex);
        pthread_cond_signal(&cond);
    }
    return nullptr;
}

static void *cv_thread2(void *data) {
    pthread_mutex_lock(&mutex);
    for (int i = 0; i < N + WarmUp; ++i) {
        while (counter % 2 == 0) {
            pthread_cond_wait(&cond, &mutex);
        }
        t2 = __rdtsc();
        if (i >= WarmUp) {
            total_t += t2 - t1;
        }
        ++counter;
        pthread_mutex_unlock(&mutex);
        pthread_cond_signal(&cond);
    }
    return nullptr;
}

static void test_cv() {
    total_t = 0;
    counter = 0;
    pthread_t t1, t2;
    pthread_create(&t1, nullptr, cv_thread1, nullptr);
    pthread_create(&t2, nullptr, cv_thread2, nullptr);
    pthread_join(t1, nullptr);
    pthread_join(t2, nullptr);
    printf("%f\n", total_t * factor / N);
}

static void *futex_thread1(void *data) {
    sleep(1);
    while (true) {
        while (counter) {
            assert(auto_syscall(SYS_futex, &counter, FUTEX_PRIVATE_FLAG | FUTEX_WAIT, 1, nullptr) == 0);
        }
        counter = !counter;
        t1 = __rdtsc();
        assert(auto_syscall(SYS_futex, &counter, FUTEX_PRIVATE_FLAG | FUTEX_WAKE, 1) >= 0);
    }
    return nullptr;
}

static void *futex_thread2(void *data) {
    pthread_mutex_lock(&mutex);
    for (int i = 0; i < N + WarmUp; ) {
        bool wake = false;
        while (!counter) {
            int res = auto_syscall(SYS_futex, &counter, FUTEX_PRIVATE_FLAG | FUTEX_WAIT, 0, nullptr);
            wake = res == 0;
        }
        t2 = __rdtsc();
        if (wake) {
            if (i > WarmUp) {
                total_t += t2 - t1;
            }
            ++i;
        }
        counter = !counter;
        assert(auto_syscall(SYS_futex, &counter, FUTEX_PRIVATE_FLAG | FUTEX_WAKE, 1) >= 0);
    }
    return nullptr;
}

static void test_futex() {
    total_t = 0;
    counter = 0;
    pthread_t t1, t2;
    pthread_create(&t1, nullptr, futex_thread1, nullptr);
    pthread_create(&t2, nullptr, futex_thread2, nullptr);
    //pthread_join(t1, nullptr);
    pthread_join(t2, nullptr);
    printf("%f\n", total_t * factor / N);
}

struct VDSOData {
    uint32_t seq;
    int32_t clock_mode;
    uint64_t cycle_last;
    uint64_t mask;
    uint32_t mult;
    uint32_t shift;
};

int main(int argc, char **argv) {
    use_pegasus = atoi(argv[1]);
    cpu_set_t set;
    CPU_ZERO(&set);
    CPU_SET(0, &set);
    pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &set);
    uint8_t *vdso = (uint8_t *)getauxval(AT_SYSINFO_EHDR);
    VDSOData *vdso_data = (VDSOData *)(vdso - 4096 * 4 + 128);
    factor = ((double)vdso_data->mult) / (1 << vdso_data->shift);
    test_cv();
    test_futex();
    return 0;
}
