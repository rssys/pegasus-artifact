#include <cstdio>
#include <cinttypes>
#include <unistd.h>
#include <fcntl.h>
#include <sys/auxv.h>

struct Data {
    uint64_t tag;
    uint64_t timestamp;
};

uint64_t mask;
uint64_t mult;
uint32_t shift;

double get_ns(uint64_t cycles) {
    return (cycles * mult) >> shift;
    //return cycles;
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
    int fd = open(argv[1], O_RDONLY);
    if (fd == -1) {
        perror("open");
        return 1;
    }
    ssize_t size = lseek(fd, 0, SEEK_END);
    if (size == -1) {
        perror("lseek");
        return 1;
    }
    char *buf = new char[size];
    if (pread(fd, buf, size, 0) == -1) {
        perror("pread");
        return 1;
    }
    close(fd);
    Data *data = (Data *)buf;
    uint64_t count = data[0].tag;
    uint64_t t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    uint64_t T1 = 0, T2 = 0, T3 = 0, T4 = 0, T5 = 0, T6 = 0, T7 = 0, T8 = 0, T9 = 0, T10 = 0;
    uint64_t n = 0;
    Data *p;
    for (uint64_t i = 1; i < count; ) {
        const int pattern[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0};
        for (int j = 0; j < 10; ++j) {
            if (data[i + j].tag != pattern[j]) {
                goto fail;
            }
        }
        p = &data[i];
        t1 = p[1].timestamp - p[0].timestamp;
        t2 = p[2].timestamp - p[1].timestamp;
        t3 = p[3].timestamp - p[2].timestamp;
        t4 = p[4].timestamp - p[3].timestamp;
        t5 = p[5].timestamp - p[4].timestamp;
        t6 = p[6].timestamp - p[5].timestamp;
        t7 = p[7].timestamp - p[6].timestamp;
        t8 = p[8].timestamp - p[7].timestamp;
        t9 = p[9].timestamp - p[8].timestamp;
        t10 = p[10].timestamp - p[9].timestamp;
        i += 10;
        ++n;
        T1 += t1;
        T2 += t2;
        T3 += t3;
        T4 += t4;
        T5 += t5;
        T6 += t6;
        T7 += t7;
        T8 += t8;
        T9 += t9;
        T10 += t10;
        continue;
fail:
        ++i;
    }
    uint8_t *vdso = (uint8_t *)getauxval(AT_SYSINFO_EHDR);
    VDSOData *vdso_data = (VDSOData *)(vdso - 4096 * 4 + 128);
    mult = vdso_data->mult;
    mask = vdso_data->mask;
    shift = vdso_data->shift;
    printf("%lx %lx %d\n", mult, mask, shift);
    double T = T1 + T2 + T3 + T4 + T5 + T6 + T7 + T8 + T9 + T10;

    printf("%f %f %f %f %f %f %f %f %f %f %f\n",
        get_ns(T1) / n,
        get_ns(T2) / n,
        get_ns(T3) / n,
        get_ns(T4) / n,
        get_ns(T5) / n,
        get_ns(T6) / n,
        get_ns(T7) / n,
        get_ns(T8) / n,
        get_ns(T9) / n, 
        get_ns(T10) / n,
        get_ns(T) / n); 
    return 0;
}
