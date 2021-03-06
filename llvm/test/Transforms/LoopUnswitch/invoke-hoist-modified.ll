; RUN: opt -loop-unswitch -enable-new-pm=0 %s -S | FileCheck %s

; When hoisting simple values out from a loop, and not being able to unswitch
; the loop due to the invoke instruction, the pass would return an incorrect
; Modified status. This was caught by the pass return status check that is
; hidden under EXPENSIVE_CHECKS.

; CHECK-LABEL: for.cond:
; CHECK-NEXT: %0 = call i32 @llvm.objectsize.i32.p0i8(i8* bitcast (%struct.anon* @b to i8*), i1 false, i1 false, i1 false)
; CHECK-NEXT: %1 = icmp uge i32 %0, 1
; CHECK-NEXT: br label %for.inc

%struct.anon = type { i16 }

@b = global %struct.anon zeroinitializer, align 1

; Function Attrs: nounwind
define i32 @c() #0 personality i32 (...)* @__CxxFrameHandler3 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %cont, %entry
  br label %for.inc

for.inc:                                          ; preds = %for.cond
  %0 = call i32 @llvm.objectsize.i32.p0i8(i8* bitcast (%struct.anon* @b to i8*), i1 false, i1 false, i1 false)
  %1 = icmp uge i32 %0, 1
  br i1 %1, label %delete.notnull, label %delete.notnull

delete.notnull:                                   ; preds = %for.inc
  invoke void @g() to label %invoke.cont unwind label %lpad

invoke.cont:                                      ; preds = %delete.notnull
  br label %for.inc

lpad:                                             ; preds = %delete.notnull
  %cp = cleanuppad within none []
  cleanupret from %cp unwind to caller

cont:                                             ; preds = %for.inc
  %2 = load i16, i16* getelementptr inbounds (%struct.anon, %struct.anon* @b, i32 0, i32 0), align 1
  br label %for.cond
}

; Function Attrs: nounwind readnone speculatable willreturn
declare i32 @llvm.objectsize.i32.p0i8(i8*, i1 immarg, i1 immarg, i1 immarg) #1

declare void @g()

declare i32 @__CxxFrameHandler3(...)

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone speculatable willreturn }
