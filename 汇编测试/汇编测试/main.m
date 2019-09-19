//
//  main.m
//  汇编测试
//
//  Created by bus365-04 on 2019/9/19.
//  Copyright © 2019 MrLu. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}


int add_a_and_b(int a, int b) {
   return a + b;
}

int main() {
   return add_a_and_b(2, 3);
}


_add_a_and_b:
   push   %ebx
   mov    %eax, [%esp+8]
   mov    %ebx, [%esp+12]
   add    %eax, %ebx
   pop    %ebx
   ret

_main:
   push   3
   push   2
   call   _add_a_and_b
   add    %esp, 8
   ret
