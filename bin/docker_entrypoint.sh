# bash -l -c '/usr/bin/env'

DATABASE_URL="mysql2://admin:${MYSQL_ENV_MYSQL_PASS}@${MYSQL_PORT_3306_TCP_ADDR}:${MYSQL_PORT_3306_TCP_PORT}/content_guard_development"
REDIS_URL="redis://${REDIS_PORT_6379_TCP_ADDR}:${REDIS_PORT_6379_TCP_PORT}${REDIS_NAME}"

grep -q DATABASE_URL   .env.docker || echo "DATABASE_URL=${DATABASE_URL}" >> .env
grep -q REDIS_URL      .env.docker || echo "REDIS_URL=${REDIS_URL}" >> .env

bash -l -c 'bin/rake db:create; exit 0'
bash -l -c 'bin/rake db:migrate db:seed'
bash -l -c 'bin/rake assets:precompile'

bash -l -c 'bin/rails server'
