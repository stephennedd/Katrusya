import { Knex } from 'knex';
require('dotenv').config(); 

// console.log(process.env.DB_HOST);
// console.log(parseInt(process.env.DB_PORT));
// console.log(process.env.DB_USER)
// console.log(process.env.DB_PASSWORD)
// console.log(process.env.DB_NAME);
// console.log(process.env.DB_TIMEZONE);
// console.log("frfrf");

const config: Knex.Config = {
    client: 'mysql2',
    connection: {
        // host: 'localhost',
        // user: 'root',
        // password: 'Liverpool599570',
        // database: 'katrusya',
        // timezone: '+00:00'
        // host: 'db', 
        // port: 3306,
        // user: 'MoSalah',
        // password: 'qwerty123',
        // database: 'katrusya',
        // timezone: '+00:00' // set session timezone to UTC
        host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
 timezone: process.env.DB_TIMEZONE
    },
    migrations: {
        directory: './migrations'
    },
    seeds: {
        directory: './seeds'
      }
};

// const config: Knex.Config = {
//     client: 'mysql2',
//     connection: {
//         host: 'localhost',
//         user: 'root',
//         password: 'StephenNedd',
//         database: 'katrusya',
//         timezone: '+00:00' // set session timezone to UTC
//     },
//     migrations: {
//         directory: './migrations'
//     },
//     seeds: {
//         directory: './seeds'
//       }
// };

export default config;