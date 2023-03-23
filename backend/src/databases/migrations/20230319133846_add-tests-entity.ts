import { Knex } from "knex";


export async function up(knex: Knex): Promise<void> {
await knex.schema.createTable('courses', function (t) {
    t.increments();
    t.string('title');
    t.string('description');
    // t.integer('user_id').unsigned();
    // t.foreign('user_id').references('id').inTable('users');
    t.timestamps();
});


    await knex.schema.createTable('sections', function (t) {
        t.increments();
        t.string('title');
        t.string('description');
        t.integer('course_id').unsigned();
        t.foreign('course_id').references('id').inTable('courses');
        t.timestamps();
      });

      await knex.schema.createTable('lessons', function (t) {
        t.increments();
        t.string('title');
        t.string('description');
        t.integer('section_id').unsigned();
        t.foreign('section_id').references('id').inTable('sections');
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
      await knex.schema.dropTable('tests');
      await knex.schema.dropTable('lessons');
        await knex.schema.dropTable('sections');
        await knex.schema.dropTable('courses');
    }