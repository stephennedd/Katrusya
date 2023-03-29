import { Knex } from "knex";


export async function up(knex: Knex): Promise<void> {
    await knex.schema.createTable('users', function (t) {
        t.increments();
        t.string('user_guid').unique();
        t.string('name');
        t.string('username');
        t.string('avatar');
        t.string('email').unique();
        t.string('phone').unique();
        t.string('password').nullable();
        t.boolean('is_active').defaultTo(false);
        t.string('email_verified_at').nullable();
        t.boolean('email_confirmed').defaultTo(false);
        t.timestamps();
    });

    return knex.schema.createTable('user_otps', function (t) {
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

}


export async function down(knex: Knex): Promise<void> {
    await knex.schema.dropTable('user_otps');
    await knex.schema.dropTable('users');
}

