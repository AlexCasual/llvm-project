; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Test shortening of NILL to NILF when the result is used as a shift amount.
;
; RUN: llc < %s -mtriple=s390x-linux-gnu | FileCheck %s

; Test logical shift right.
define i32 @f1(i32 %a, i32 %sh) {
; CHECK-LABEL: f1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    nill %r3, 31
; CHECK-NEXT:    srl %r2, 0(%r3)
; CHECK-NEXT:    br %r14
  %and = and i32 %sh, 31
  %shift = lshr i32 %a, %and
  ret i32 %shift
}

; Test arithmetic shift right.
define i32 @f2(i32 %a, i32 %sh) {
; CHECK-LABEL: f2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    nill %r3, 31
; CHECK-NEXT:    sra %r2, 0(%r3)
; CHECK-NEXT:    br %r14
  %and = and i32 %sh, 31
  %shift = ashr i32 %a, %and
  ret i32 %shift
}

; Test shift left.
define i32 @f3(i32 %a, i32 %sh) {
; CHECK-LABEL: f3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    nill %r3, 31
; CHECK-NEXT:    sll %r2, 0(%r3)
; CHECK-NEXT:    br %r14
  %and = and i32 %sh, 31
  %shift = shl i32 %a, %and
  ret i32 %shift
}

; Test 64-bit logical shift right.
define i64 @f4(i64 %a, i64 %sh) {
; CHECK-LABEL: f4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    nill %r3, 31
; CHECK-NEXT:    srlg %r2, %r2, 0(%r3)
; CHECK-NEXT:    br %r14
  %and = and i64 %sh, 31
  %shift = lshr i64 %a, %and
  ret i64 %shift
}

; Test 64-bit arithmetic shift right.
define i64 @f5(i64 %a, i64 %sh) {
; CHECK-LABEL: f5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    nill %r3, 31
; CHECK-NEXT:    srag %r2, %r2, 0(%r3)
; CHECK-NEXT:    br %r14
  %and = and i64 %sh, 31
  %shift = ashr i64 %a, %and
  ret i64 %shift
}

; Test 64-bit shift left.
define i64 @f6(i64 %a, i64 %sh) {
; CHECK-LABEL: f6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    nill %r3, 31
; CHECK-NEXT:    sllg %r2, %r2, 0(%r3)
; CHECK-NEXT:    br %r14
  %and = and i64 %sh, 31
  %shift = shl i64 %a, %and
  ret i64 %shift
}

; Test shift with negative 32-bit value.
define i32 @f8(i32 %a, i32 %sh, i32 %test) {
; CHECK-LABEL: f8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    nill %r3, 65529
; CHECK-NEXT:    sll %r2, 0(%r3)
; CHECK-NEXT:    br %r14
  %and = and i32 %sh, -7
  %shift = shl i32 %a, %and

  ret i32 %shift
}

; Test shift with negative 64-bit value.
define i64 @f9(i64 %a, i64 %sh, i64 %test) {
; CHECK-LABEL: f9:
; CHECK:       # %bb.0:
; CHECK-NEXT:    nill %r3, 65529
; CHECK-NEXT:    sllg %r2, %r2, 0(%r3)
; CHECK-NEXT:    br %r14
  %and = and i64 %sh, -7
  %shift = shl i64 %a, %and

  ret i64 %shift
}
