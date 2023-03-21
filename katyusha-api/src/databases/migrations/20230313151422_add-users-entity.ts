import { Knex } from "knex";


export async function up(knex: Knex): Promise<void> {
    return knex.schema.createTable('users', function (t) {
        t.increments();
        t.string('user_guid').unique();
        t.string('name');
        t.string('avatar');
        t.string('email').unique();
        t.string('password').nullable();
        t.boolean('is_active').defaultTo(false);
        t.string('email_verified_at').nullable();
        t.timestamps();
    });

}


export async function down(knex: Knex): Promise<void> {
    return knex.schema.dropTable('users');
}

