{
  _id: ObjectId,

  title: String,
  description: String,
  price: Number,
  level: "beginner" | "intermediate" | "advanced",
  is_published: Boolean,
  created_at: Date,

  instructor: {
    instructor_id: ObjectId,
    full_name: String,
    email: String
  },

  modules: [
    {
      module_id: ObjectId,
      title: String,
      module_order: Number,

      lessons: [
        {
          lesson_id: ObjectId,
          title: String,
          lesson_type: "video" | "article" | "coding",
          content: String,
          lesson_order: Number,
          created_at: Date,

          code_submissions: [
            {
              submission_id: ObjectId,
              user_id: ObjectId,
              code: String,
              language: String,
              result: "pass" | "fail",
              submitted_at: Date
            }
          ]
        }
      ]
    }
  ],

  enrollments: [
    {
      user_id: ObjectId,
      full_name: String,
      email: String,
      enrolled_at: Date,

      lesson_progress: [
        {
          lesson_id: ObjectId,
          completed: Boolean,
          completed_at: Date
        }
      ],

      certificate: {
        issued: Boolean,
        issued_at: Date
      },

      payment: {
        amount: Number,
        payment_status: "pending" | "completed" | "failed",
        payment_provider: String,
        created_at: Date
      }
    }
  ]
}
