import { Knex } from "knex";


const courseData = require("../courseData.json");
const userData = require("../userData.json");
const categoryData = require("../categoryData.json")

interface Category {
  id:number;
  name:string;
  icon:string;
}

interface User {
 name: string;
 avatar: string;
  email: string
  password: string;
  is_active: boolean;
  email_verified_at: string;
  roles: string[];
}

interface UserResults {
  userId: number;
  testId: number;
  numberOfHpPoints: number;
}

interface Lesson {
    title: string;
    description: string;
    duration_in_hours: number;
    videoUrl: string;
    image: string;
  }

  interface Test {
    id: number,
    title: string;
      image_url: string;
      description: string;
      time_seconds: number;
      section_id: number;
      course_id: number;
      questions: [Question];
   }

   interface Question {
    id: number,
    question: string;
    correct_answer: string;
    selected_answer:string;
    answers:[Answer];
   }

   interface Answer {
    id: number,
    identifier: string;
    answer: string;
   }
  
  interface Section {
    id: number,
    title: string;
    image:string;
    description: string;
    course_id: number;
    lessons: Lesson[];
    duration_in_hours: number;
     test: Test;
  }
  
  interface Course {
    id: number,
    name: string;
    description: string;
    image: string;
    price: string;
    session: string;
    review: string;
    is_favorited: boolean;
    is_recommended: boolean;
    is_featured: boolean;
    duration_in_hours: number;
    // number_of_lessons: number;
    tags: [string];
  }

export async function seed(knex: Knex): Promise<void> {

  const users: User[] = await knex("users").insert({
    name: userData.name,
 avatar: userData.avatar,
  email: userData.email,
  password: userData.password,
  is_active: userData.is_active,
  email_verified_at: userData.email_verified_at,
  roles:JSON.stringify(userData.user_roles)
  });

  for(let i = 0;i<categoryData.categories.length;i++){
    await knex("categories").insert({
    name: categoryData.categories[i].name,
    icon: categoryData.categories[i].icon
  });}

  // insert courses
  let courses: Course[] = [];
  for(let i = 0;i<courseData.courses.length;i++){
    courses = await knex("courses").insert({
    name: courseData.courses[i].name,
    description: courseData.courses[i].description,
    image: courseData.courses[i].image,
    price: courseData.courses[i].price,
    // number_of_lessons: courseData.courses[i].number_of_lessons,
    duration_in_hours: courseData.courses[i].duration_in_hours,
    review: courseData.courses[i].review,
    is_favorited: courseData.courses[i].is_favorited,
    is_recommended: courseData.courses[i].is_recommended,
    is_featured: courseData.courses[i].is_featured,
    tags: JSON.stringify(courseData.courses[i].course_tags),
  });
}

// insert course_category entries for each course and its associated categories
for(let i = 0;i<courseData.courses.length;i++){
  for(let j = 0;j<courseData.courses[i].category_ids.length;j++){
    await knex("course_categories").insert({
      course_id: courseData.courses[i].id,
      category_id: courseData.courses[i].category_ids[j]
    });
  }
}
  
let sections: Section[] = [];
for(let i = 0; i<courseData.courses.length;i++){
  sections  = (await Promise.all(courseData.courses[i].sections.map(async (section: Section) => {
    return await knex("sections").insert({
      title: section.title,
      description: section.description,
      duration_in_hours: section.duration_in_hours,
      course_id: courseData.courses[i].id,
      image: section.image
    })
  }))).flat();
}
  
  //insert lessons
  let lessons: Lesson[] = [];
for(let i = 0; i<courseData.courses.length;i++){
    lessons = (await Promise.all(courseData.courses[i].sections.map(async (section: Section) => {
    return await Promise.all(section.lessons.map(async (lesson: Lesson) => {
      return await knex("lessons").insert({
        title: lesson.title,
        description: lesson.description,
        duration_in_hours: lesson.duration_in_hours,
        video_url: lesson.videoUrl,
        image: lesson.image,
        section_id: section.id,
      })
    }));
  })));
}

  // insert tests
  let tests: Test[] = [];
for(let i = 0; i<courseData.courses.length;i++){
  tests = await Promise.all(courseData.courses[i].sections.map(async (section: Section) => {
     await knex("tests").insert({
        title: section.test.title,
      image_url: section.test.image_url,
      description: section.test.description,
      time_seconds: section.test.time_seconds,
      section_id: section.id,
      course_id: courseData.courses[i].id
      });
    await Promise.all(section.test.questions.map(async (question) => {
         await knex("questions").insert({
          question: question.question,
          correct_answer: question.correct_answer,
          test_id: section.test.id,
        });
  
        await Promise.all(question.answers.map(async (answer) => {
          return await knex("answers").insert({
            identifier: answer.identifier,
            answer: answer.answer,
            question_id: question.id,
          });
        }));
      }));
  }
  ));
}

for(let i = 0;i<userData.user_courses.length;i++){
  await knex("user_courses").insert({
  user_id: userData.user_courses[i].user_id,
  course_id: userData.user_courses[i].course_id
});}


//   await knex("user_results").insert({
//   user_id: userData.user_results.user_id,
//   test_id: userData.user_results.test_id,
//   number_of_hp_points: userData.user_results.number_of_hp_points
// });
}
