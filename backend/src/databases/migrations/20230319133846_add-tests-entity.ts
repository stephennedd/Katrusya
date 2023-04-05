import { Knex } from "knex";


export async function up(knex: Knex): Promise<void> {

  await knex.schema.createTable('users', function (t) {
    t.increments();
    t.string('user_guid').unique();
    t.string('name');
    t.string('username');
    t.integer('balance_of_tokens').defaultTo(0);
    t.string('avatar');
    t.string('email').unique();
    t.string('phone').unique();
    t.string('password').nullable();
    t.boolean('is_active').defaultTo(false);
    t.json('roles');
    t.string('email_verified_at').nullable();
    t.boolean('email_confirmed').defaultTo(false);
    t.timestamps();
});

await knex.schema.createTable('user_otps', function (t) {
    t.increments();
    t.string('activationCode').unique();
    t.boolean('isExpired');
    t.bigInteger('expiryTime');
    t.boolean('isMobileOtp');
    t.integer('requestCount');
    t.integer('userId').unsigned().unique();
    t.foreign('userId').references('id').inTable('users');
    t.timestamps();
});
await knex.schema.createTable('courses', function (t) {
    t.increments();
    t.string('name');
    t.string('description',2000);
    t.string('image',2000);
    t.string('price');
    // t.integer('number_of_lessons');
    // t.integer('number_of_sections');
    t.integer('duration_in_hours');
    t.string('review');
    t.boolean('is_favorited');
    t.boolean('is_recommended');
    t.boolean('is_featured');
    t.json('tags');
    t.timestamps();
});

await knex.schema.createTable('user_favorite_courses', function (t) {
  t.increments();
  t.integer('user_id').unsigned();
  t.foreign('user_id').references('id').inTable('users');
  t.integer('course_id').unsigned();
  t.foreign('course_id').references('id').inTable('courses');
  t.unique(['user_id', 'course_id']); // ensure unique combinations of course_id and user_id
  t.timestamps();
});

await knex.schema.createTable('categories', function (t) {
  t.increments();
  t.string('name');
  t.string('icon',1000);
  t.timestamps();
});

await knex.schema.createTable('course_categories', function (t) {
  t.increments();
  t.integer('course_id').unsigned();
  t.foreign('course_id').references('id').inTable('courses');
  t.integer('category_id').unsigned();
  t.foreign('category_id').references('id').inTable('categories');
  t.unique(['course_id', 'category_id']); // ensure unique combinations of course_id and category_id
  t.timestamps();
});

await knex.schema.createTable('user_courses', function (t) {
  t.increments();
  t.integer('user_id').unsigned();
  t.foreign('user_id').references('id').inTable('users');
  t.integer('course_id').unsigned();
  t.foreign('course_id').references('id').inTable('courses');
  t.boolean('is_completed').defaultTo(false);
  t.unique(['user_id', 'course_id']);
  t.timestamps();
});

    await knex.schema.createTable('sections', function (t) {
        t.increments();
        t.string('title');
        t.string('description');
        t.string('image');
        t.integer('duration_in_hours');
        t.integer('course_id').unsigned();
        t.foreign('course_id').references('id').inTable('courses');
        t.timestamps();
      });

      await knex.schema.createTable('user_completed_sections', function (t) {
        t.increments();
        t.integer('user_id').unsigned();
        t.foreign('user_id').references('id').inTable('users');
        t.integer('section_id').unsigned();
        t.foreign('section_id').references('id').inTable('sections');
        t.integer('course_id').unsigned();
        t.foreign('course_id').references('id').inTable('courses');
        t.unique(['user_id', 'section_id']);
        t.timestamps();
      });

      await knex.schema.createTable('lessons', function (t) {
        t.increments();
        t.string('title');
        t.string('description');
        t.string('video_url');
        t.string('image');
        t.integer('duration_in_hours');
        t.integer('section_id').unsigned();
        t.foreign('section_id').references('id').inTable('sections');
        t.timestamps();
      });

      await knex.schema.createTable('user_completed_lessons', function (t) {
        t.increments();
        t.integer('user_id').unsigned();
        t.foreign('user_id').references('id').inTable('users');
        t.integer('lesson_id').unsigned();
        t.foreign('lesson_id').references('id').inTable('lessons');
        t.integer('section_id').unsigned();
        t.foreign('section_id').references('id').inTable('sections');
        t.unique(['user_id', 'lesson_id']);
        t.timestamps();
      });
    
     await knex.schema.createTable('tests', function (t) {
        t.increments();
        t.string('title');
        t.string('image_url');
        t.string('description');
        t.integer('time_seconds');
        t.integer('section_id').unsigned().unique();
        t.foreign('section_id').references('id').inTable('sections');
        t.integer('course_id').unsigned()
        t.foreign('course_id').references('id').inTable('courses');
        t.timestamps();
      });

      await knex.schema.createTable('questions', function (t) {
        t.increments();
        t.string('question')
        t.string('correct_answer')
        t.string('selected_answer')
        t.integer('test_id').unsigned();
        t.foreign('test_id').references('id').inTable('tests');
        t.timestamps();
      });

      await knex.schema.createTable('answers', function (t) {
        t.increments();
        t.string('identifier');
        t.string('answer');
        t.integer('question_id').unsigned();
        t.foreign('question_id').references('id').inTable('questions');
        t.timestamps();
      });

      return knex.schema.createTable('user_results', function (t) {
        t.increments();
        t.integer('user_id').unsigned();
        t.foreign('user_id').references('id').inTable('users');
        t.integer('test_id').unsigned();
        t.foreign('test_id').references('id').inTable('tests');
        t.integer('number_of_hp_points');
        t.timestamps();
    });
    }

    export async function down(knex: Knex): Promise<void> {
     await knex.schema.dropTable('answers');
     await knex.schema.dropTable('questions');
     await knex.schema.dropTable('user_results');
     await knex.schema.dropTable('user_favorite_courses');
      await knex.schema.dropTable('tests');
      await knex.schema.dropTable('user_completed_lessons');
      await knex.schema.dropTable('lessons');
      await knex.schema.dropTable('user_completed_sections');
        await knex.schema.dropTable('sections');
        await knex.schema.dropTable('course_categories');
        await knex.schema.dropTable('categories');
        await knex.schema.dropTable('user_otps');
        await knex.schema.dropTable('user_courses');
        await knex.schema.dropTable('courses');
        await knex.schema.dropTable('users');
    }