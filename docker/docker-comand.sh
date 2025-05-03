######### DATABASE ###########

#CONTEINER
docker run -d --name estacionamento-db -e POSTGRES_DB=estacionamento -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -v db_data:/var/lib/postgresql/data -p 5432:5432 postgres:15-alpine

######### BACK ###########

#IMAGE
docker build -t estacionamento-backend:latest .      
#CONTEINER
docker run -d --name estacionamento-backend --link estacionamento-db:db -e SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/estacionamento -e SPRING_DATASOURCE_USERNAME=postgres -e SPRING_DATASOURCE_PASSWORD=postgres -p 8080:8080 estacionamento-backend:latest
                     
######### FRONT ###########

#IMAGE
docker build -t estacionamento-frontend:latest . 
#CONTEINER
docker run -d --name estacionamento-frontend --link estacionamento-backend:backend -p 3000:80 estacionamento-frontend:latest

#############################################################################################

docker network create estacionamento-net
docker network connect estacionamento-net estacionamento-db
docker network connect estacionamento-net estacionamento-backend
docker network connect estacionamento-net estacionamento-frontend


