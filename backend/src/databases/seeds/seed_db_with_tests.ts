import { Knex } from "knex";


const quizData = require("../quizData.json");
const userData = require("../userData.json")

interface User {
 name: string;
 avatar: string;
  email: string
  password: string;
  is_active: boolean;
  email_verified_at: string;
}

interface UserResults {
  userId: number;
  testId: number;
  numberOfHpPoints: number;
}

interface Lesson {
    title: string;
    description: string;
  }

  interface Test {
    id: number,
    title: string;
      image_url: string;
      description: string;
      time_seconds: number;
      section_id: number;
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
    description: string;
    course_id: number;
    lessons: Lesson[];
     test: Test;
  }
  
  interface Course {
    id: number,
    title: string;
    description: string;
  }

export async function seed(knex: Knex): Promise<void> {

  const users: User[] = await knex("users").insert({
    name: userData.name,
 avatar: userData.avatar,
  email: userData.email,
  password: userData.password,
  is_active: userData.is_active,
  email_verified_at: userData.email_verified_at
  });

  // insert courses
  const courses: Course[] = await knex("courses").insert({
    title: quizData.title,
    description: quizData.description
  });

  const sections: Section[] = (await Promise.all(quizData.sections.map(async (section: Section) => {
    return await knex("sections").insert({
      title: section.title,
      description: section.description,
      course_id: quizData.id,
    })
  }))).flat();
  
  //insert lessons
  const lessons: Lesson[] = (await Promise.all(quizData.sections.map(async (section: Section) => {
    return await Promise.all(section.lessons.map(async (lesson: Lesson) => {
      return await knex("lessons").insert({
        title: lesson.title,
        description: lesson.description,
        section_id: section.id,
      })
    }));
  })));

  // insert tests
  const tests: Test[] = await Promise.all(quizData.sections.map(async (section: Section) => {
     await knex("tests").insert({
        title: section.test.title,
      image_url: section.test.image_url,
      description: section.test.description,
      time_seconds: section.test.time_seconds,
      section_id: section.id,
      });
    console.log('Hello');
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
