/*
 * Works only on x86 & x86_64 Linux systems
 * But can be extended to work on other achitectures
 * and OS if you know the OS' ABI as well as
 * the assembly syntax for that architecture
 *
 * Supplies:
 *          * int print(char*)
 *          * int println(char*)
 *          * int printerr(char*)
 *          * int input(char* dst, int len)
 *          * long unsigned int strlen(char*)
 *
 * Note: You might want to use 'g++ -Wno-write-strings'
 *
 * Author: github.com/mkasimd
 */

// forward declaration of functions
long unsigned int strlen(char*);

// setting environment specific values and functions
#ifndef NULL
 #define NULL 0
 #ifdef __cplusplus
  #if __cplusplus > 201103L
  #undef NULL
  #define NULL nullptr
  #endif
 #endif
#endif // in case NULL wasn't defined yet, you're welcome

#ifdef linux
  #define OS 'L'
  #if defined(__x86_64__)
    #define SYSREAD 0
    #define SYSWRITE 1
  #endif
  #if defined(__i386__)
    #define SYSREAD 3
    #define SYSWRITE 4
  #endif
  #define STDIN 0
  #define STDOUT 1
  #define STDERR 2
#endif
#if _WIN32 || _WIN64
  #define OS 'W' // not yet supported, will it ever be?
#endif
#ifndef OS
  #define OS 'O' // usupported OS
#endif

#if defined(__x86_64__)
  #define ARCH 64 // amd64 architecture
#elif defined(__i386__)
  #define ARCH 86 // x86 architecture
#else
  #define ARCH 0 // unsupported CPU architecture
#endif

#define STR_IMPL_(x) #x     // stringify argument
#define STR(x) STR_IMPL_(x) // indirection to expand argument macros

#if ARCH == 64 && OS == 'L'
  // forward-declare architecture-specific functions
  int print_64(int FILE, char* msg, int len);
  int input_64(int FILE, char* dst, int len);

  // x86_64 Linux specific print & printerr functions
  int print(char* str) { return print_64(STDOUT, str, strlen(str)); }
  int printerr(char* str) { return print_64(STDERR, str, strlen(str)); }
  int input(char* dst, int len) { return input_64(STDIN, dst, len); }
#endif
#if ARCH == 86 && OS == 'L'
  int print_32(int FILE, char* msg, int len); // forward declaration
  int input_32(int FILE, char* dst, int len);

  // x86 Linux specific print & printerr functions
  int print(char* str) { return print_32(STDOUT, str, strlen(str)); }
  int printerr(char* str) { return print_32(STDERR, str, strlen(str)); }
  int input(char* dst, int len) { return input_32(STDIN, dst, len); }
#endif
#ifndef ARCH
  #define ARCH 0 // unsupported CPU architecture
#endif

#if OS != 'L' || ARCH == 0 // For unsupported OS & architectures only

// Let them repent choosing a bad OS or architecture ;)
#include <stdio.h>
int main(void) {
  fprintf(stderr, "This program solely works on x86 & x86_64 Linux systems.\n\
                    Get yourself a proper computer ;)\n");
  return -1;
}

#else // everything else: For supported OS & architectures only

// general values and macro functions
#define println(STR)                                                           \
  {                                                                            \
    print(STR);                                                                \
    print("\n");                                                               \
  }
#define ENDOF(STR) (*STR == '\0')

/*****************************************************************************
 *                                                                            *
 *                   ACTUAL CODE TO EXECUTE COMES HERE                        *
 *                                                                            *
 *****************************************************************************/

int main(void) {
  print("Yes, it works!\n");
  println("Macro expansions are awesome, aren't they? ;)");
  printerr("Of course, you can write to STDERR as well ^^\n");
  print("Try inputting text as well:\n");
  char buf[50];
  int x = input(buf, 49);
  print("You've written: ");
  println(buf);
}

/*****************************************************************************
 *                                                                            *
 *               SELF-IMPLEMENTED LIBRARY FUNCTIONS BELOW                     *
 *                                                                            *
 *****************************************************************************/

long unsigned int strlen(char* str) {
  long unsigned int size = 0;
  while (!ENDOF(str++))
    size++;
  return size;
}

#if defined(__x86_64__)
// As per x64 GCC calling convention: rdi, rsi, rdx, rcx, r8, r9, stack...
int print_64(int FILE, char* msg, int len) {
 int ret;
  __asm__(      // FILE, msg & len in the correct registers already
      "syscall" //
      : "=r"(ret)
      : "a"(SYSWRITE)
  );
  return ret;
}

int input_64(int FILE, char* dst, int len) {
  int ret = 0;
  __asm__(
      "syscall"
      : "=r"(ret)
      : "a"(SYSREAD)
  );
  dst[res] = '\0';
  return ret;
}
#endif

#if defined(__i386__)
int print_32(int FILE, char* msg, int len) {
 int ret;
  __asm__(
          "int $0x80" // system interrupt
          : "=r"(ret)
          : "a"(SYSWRITE), "b"(FILE), "c"(msg),
            "d"(len)
  ); // set register values: eax = SYS_WRITE, ebx = FILE, ...
  return ret;
}

int input_32(int FILE, char* dst, int len) {
  int ret;
  __asm__("int $0x80" //
          : "=r"(ret) //
          : "a"(SYSREAD), "b"(FILE), "c"(dst), "d"(len)
  );
  dst[ret] = '\0'; // NULL-terminate input string
  return ret;
}
#endif
#endif // end of "For supported OS & architectures only"
