json.lecture @lectures do |lecture|
  json.dayOfWeek lecture.day_of_week
  json.slot lecture.slot
  json.lectureName lecture.lecture_name
  json.teacherName lecture.teacher_name
  json.classroomName lecture.classroom_name
  json.changeStatus lecture.change_status
end
