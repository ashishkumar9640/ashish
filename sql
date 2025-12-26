-- ===============================
-- ENABLE EXTENSIONS
-- ===============================
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ===============================
-- USERS
-- ===============================
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    phone VARCHAR(20),
    profile_image TEXT,
    bio TEXT,
    role VARCHAR(20) 
        CHECK (role IN ('student', 'instructor', 'admin')) DEFAULT 'student',
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- COURSE CATEGORIES
-- ===============================
CREATE TABLE course_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- ===============================
-- COURSES
-- ===============================
CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    instructor_id UUID REFERENCES users(id) ON DELETE CASCADE,
    category_id UUID REFERENCES course_categories(id),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) DEFAULT 0.00,
    level VARCHAR(20) 
        CHECK (level IN ('beginner', 'intermediate', 'advanced')),
    duration_hours INT,
    language VARCHAR(50) DEFAULT 'English',
    thumbnail_url TEXT,
    rating DECIMAL(2,1) CHECK (rating BETWEEN 0 AND 5),
    total_enrollments INT DEFAULT 0,
    approved BOOLEAN DEFAULT FALSE,
    is_published BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- MODULES
-- ===============================
CREATE TABLE modules (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    module_order INT NOT NULL,
    is_locked BOOLEAN DEFAULT FALSE,
    release_date DATE
);

-- ===============================
-- LESSONS
-- ===============================
CREATE TABLE lessons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id UUID REFERENCES modules(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    lesson_type VARCHAR(20)
        CHECK (lesson_type IN ('video', 'article', 'coding', 'quiz')),
    content TEXT,
    video_url TEXT,
    duration_minutes INT,
    resources JSONB,
    is_preview BOOLEAN DEFAULT FALSE,
    lesson_order INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- ENROLLMENTS
-- ===============================
CREATE TABLE enrollments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    course_id UUID REFERENCES courses(id) ON DELETE CASCADE,
    progress_percentage DECIMAL(5,2) DEFAULT 0,
    completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, course_id)
);

-- ===============================
-- LESSON PROGRESS
-- ===============================
CREATE TABLE lesson_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE,
    completed BOOLEAN DEFAULT FALSE,
    completed_at TIMESTAMP,
    UNIQUE (user_id, lesson_id)
);

-- ===============================
-- ASSIGNMENTS
-- ===============================
CREATE TABLE assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE,
    title VARCHAR(150),
    description TEXT,
    max_score INT DEFAULT 100,
    due_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- ASSIGNMENT SUBMISSIONS
-- ===============================
CREATE TABLE assignment_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    assignment_id UUID REFERENCES assignments(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    submission TEXT,
    score INT,
    feedback TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (assignment_id, user_id)
);

-- ===============================
-- QUIZZES
-- ===============================
CREATE TABLE quizzes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE,
    title VARCHAR(150),
    total_marks INT,
    pass_marks INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- QUIZ QUESTIONS
-- ===============================
CREATE TABLE quiz_questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_id UUID REFERENCES quizzes(id) ON DELETE CASCADE,
    question TEXT,
    options JSONB,
    correct_answer TEXT
);

-- ===============================
-- QUIZ ATTEMPTS
-- ===============================
CREATE TABLE quiz_attempts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_id UUID REFERENCES quizzes(id),
    user_id UUID REFERENCES users(id),
    score INT,
    passed BOOLEAN,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- CODE SUBMISSIONS
-- ===============================
CREATE TABLE code_submissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    lesson_id UUID REFERENCES lessons(id) ON DELETE CASCADE,
    code TEXT NOT NULL,
    language VARCHAR(30),
    result VARCHAR(20) 
        CHECK (result IN ('pass', 'fail')),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- PAYMENTS
-- ===============================
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    course_id UUID REFERENCES courses(id),
    transaction_id VARCHAR(100) UNIQUE,
    amount DECIMAL(10,2),
    currency VARCHAR(10) DEFAULT 'INR',
    payment_status VARCHAR(20)
        CHECK (payment_status IN ('pending', 'completed', 'failed')),
    payment_provider VARCHAR(50),
    paid_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- COUPONS
-- ===============================
CREATE TABLE coupons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE,
    discount_percentage INT CHECK (discount_percentage BETWEEN 1 AND 100),
    expiry_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

-- ===============================
-- COURSE REVIEWS
-- ===============================
CREATE TABLE course_reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    course_id UUID REFERENCES courses(id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, course_id)
);

-- ===============================
-- CERTIFICATES
-- ===============================
CREATE TABLE certificates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    course_id UUID REFERENCES courses(id),
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, course_id)
);

-- ===============================
-- NOTIFICATIONS
-- ===============================
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    message TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===============================
-- AUDIT LOGS
-- ===============================
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    action VARCHAR(100),
    entity VARCHAR(50),
    entity_id UUID,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

