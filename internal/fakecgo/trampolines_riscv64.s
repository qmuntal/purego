// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Ebitengine Authors

//go:build !cgo && linux

#include "textflag.h"
#include "go_asm.h"

// these trampolines map the gcc ABI to Go ABI and then calls into the Go equivalent functions.
// X5 is used as temporary register.

TEXT x_cgo_init_trampoline(SB), NOSPLIT, $16
	MOV  ·x_cgo_init_call(SB), X5
	MOV  (X5), X5
	CALL X5
	RET

TEXT x_cgo_thread_start_trampoline(SB), NOSPLIT, $8
	MOV  ·x_cgo_thread_start_call(SB), X5
	MOV  (X5), X5
	CALL X5
	RET

TEXT x_cgo_setenv_trampoline(SB), NOSPLIT, $8
	MOV  ·x_cgo_setenv_call(SB), X5
	MOV  (X5), X5
	CALL X5
	RET

TEXT x_cgo_unsetenv_trampoline(SB), NOSPLIT, $8
	MOV  ·x_cgo_unsetenv_call(SB), X5
	MOV  (X5), X5
	CALL X5
	RET

TEXT x_cgo_notify_runtime_init_done_trampoline(SB), NOSPLIT, $0
	CALL ·x_cgo_notify_runtime_init_done(SB)
	RET

TEXT x_cgo_bindm_trampoline(SB), NOSPLIT, $0
	CALL ·x_cgo_bindm(SB)
	RET

// func setg_trampoline(setg uintptr, g uintptr)
TEXT ·setg_trampoline(SB), NOSPLIT, $0
	MOV  gp+8(FP), X10
	MOV  setg+0(FP), X5
	CALL X5
	RET

TEXT threadentry_trampoline(SB), NOSPLIT, $200
	// See crosscall2. Save C callee-saved registers at C-to-Go boundary.
	// RISC-V callee-saved: s0-s11 (X8,X9,X18-X26,g), fs0-fs11 (F8,F9,F18-F27)
	MOV X10, 8(SP) // arg

	MOV X8, (8*2)(SP)   // s0
	MOV X9, (8*3)(SP)   // s1
	MOV X18, (8*4)(SP)  // s2
	MOV X19, (8*5)(SP)  // s3
	MOV X20, (8*6)(SP)  // s4
	MOV X21, (8*7)(SP)  // s5
	MOV X22, (8*8)(SP)  // s6
	MOV X23, (8*9)(SP)  // s7
	MOV X24, (8*10)(SP) // s8
	MOV X25, (8*11)(SP) // s9
	MOV X26, (8*12)(SP) // s10
	MOV g, (8*13)(SP)   // s11 (X27)

	MOVD F8, (8*14)(SP)  // fs0
	MOVD F9, (8*15)(SP)  // fs1
	MOVD F18, (8*16)(SP) // fs2
	MOVD F19, (8*17)(SP) // fs3
	MOVD F20, (8*18)(SP) // fs4
	MOVD F21, (8*19)(SP) // fs5
	MOVD F22, (8*20)(SP) // fs6
	MOVD F23, (8*21)(SP) // fs7
	MOVD F24, (8*22)(SP) // fs8
	MOVD F25, (8*23)(SP) // fs9
	MOVD F26, (8*24)(SP) // fs10
	MOVD F27, (8*25)(SP) // fs11

	MOV  ·threadentry_call(SB), X5
	MOV  (X5), X5
	CALL X5

	MOV (8*2)(SP), X8
	MOV (8*3)(SP), X9
	MOV (8*4)(SP), X18
	MOV (8*5)(SP), X19
	MOV (8*6)(SP), X20
	MOV (8*7)(SP), X21
	MOV (8*8)(SP), X22
	MOV (8*9)(SP), X23
	MOV (8*10)(SP), X24
	MOV (8*11)(SP), X25
	MOV (8*12)(SP), X26
	MOV (8*13)(SP), g

	MOVD (8*14)(SP), F8
	MOVD (8*15)(SP), F9
	MOVD (8*16)(SP), F18
	MOVD (8*17)(SP), F19
	MOVD (8*18)(SP), F20
	MOVD (8*19)(SP), F21
	MOVD (8*20)(SP), F22
	MOVD (8*21)(SP), F23
	MOVD (8*22)(SP), F24
	MOVD (8*23)(SP), F25
	MOVD (8*24)(SP), F26
	MOVD (8*25)(SP), F27

	RET

TEXT ·call5(SB), NOSPLIT, $0-48
	MOV  fn+0(FP), X5
	MOV  a1+8(FP), X10
	MOV  a2+16(FP), X11
	MOV  a3+24(FP), X12
	MOV  a4+32(FP), X13
	MOV  a5+40(FP), X14
	CALL X5
	MOV  X10, ret+48(FP)
	RET
