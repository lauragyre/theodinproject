class LessonCompletionDataSerializer
  def initialize(course, start_date, end_date)
    @course = course
    @lesson_completion_data = LessonCompletionData.new(@course, start_date, end_date)
  end

  def as_json
    {@course.title => course_data_hash.merge(lessons_data_hash)}
  end

  def self.as_json(course, start_date, end_date = Time.now)
    new(course, start_date, end_date).as_json
  end

  private

  def lessons_data_hash
    lessons = @lesson_completion_data.lessons_with_known_completion_durations
    lessons.reduce({}) do |hash, lesson|
      hash[lesson.title] = lesson_data_hash(lesson)
      hash
    end
  end

  def course_data_hash
    {
      'course_duration' => @lesson_completion_data.course_duration_string
    }
  end

  def lesson_data_hash(lesson)
    {
      'lesson_weight' => @lesson_completion_data.lesson_weight(lesson),
      'percentage' => @lesson_completion_data.lesson_percentage(lesson),
      'duration' => @lesson_completion_data.lesson_duration(lesson),
      '# of Lesson Completions calculated' => @lesson_completion_data\
      .lesson_completions_count(lesson)
    }
  end
end
