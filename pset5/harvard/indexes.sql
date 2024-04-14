CREATE INDEX "courses_semester_department_idx" ON "courses"("semester","department");
CREATE INDEX "enrollments_student_id_idx" ON "enrollments"("student_id", "course_id");
CREATE INDEX "enrollment_course_id_idx" ON "enrollments"("course_id");
CREATE INDEX "satisfies_courses_id_idx" ON "satisfies"("course_id");

