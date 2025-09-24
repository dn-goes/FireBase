# CineFavorite - Formativa
Construindo um aplicativo do Zero - O CineFavorite permitirá criar uma conta e buscar filme em uma API e montar uma galeria pessoal de filmes favoritos com capas e notas.

## Objetivos
- Intregar o Aplicativo a uma API
- Criar uam conta pessoal no FireBase
- Armazenar informações para Cada usuarios das preferencias solicitadas
- Consultar informações de Filmes (Capas, Titulo)

## Levantamento de requisitos 

- Funcionais
    - Criar conta


- Nao funcionais 
    - Armazenar uma conta da Api no FireBase

## Diagramas do projeto
    diagrama que demonstra as entidades da aplicação

    - usuario (user) : classe criada pelo FireBase
        - email
        - senha
        - id
        - Create()
        - login()
        - Logout()

    - Filme (Movie) : Classe modelada pelo dev
        - number id:
        - String titulo:
        - String PosterPath:
        - bollean favorito:
        - double Nota:
        - adicionar()
        - update()
        - remover()
        - listarFavoritos()


```mermaid

    class User{
        +String uid:
        +String Email:
        +String password:
        +CreateUSer()
        +login()
        +logout()
    }

    class Movie{
        +String id
        +String title
        +String PosterPath
        +Boolean Favorite
        +double Rating
        +adicionarFavorito()
        +removeFavorite()
        +updateReating()
        +read()
    }

    User "1"--"1+" Movies : " selcionar"

```

classDiagram

## Prototipagem 

## Codificação