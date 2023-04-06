import { Knex } from 'knex';

const config: Knex.Config = {
    client: 'mysql2',
    connection: {
        host: 'localhost',
        user: 'root',
        password: 'StephenNedd',
        database: 'katrusya'
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
//         password: 'Liverpool599570',
//         database: 'katrusya'
//     },
//     migrations: {
//         directory: './migrations'
//     },
//     seeds: {
//         directory: './seeds'
//       }
// }; 

export default config;