# Cadê Buffet?

## Introduction

This is a Ruby on Rails application that allows customers to hire a buffet for a specific event/holiday and buffet owners to list their buffet and associated events for hire. It includes many features for both customers and buffet owners, such as multiple pricing options based on weekends, a user-to-user message chat and buffet ratings after the event is concluded.

<p align="center">
  <a href="https://www.ruby-lang.org/">
    <img src="https://img.shields.io/badge/ruby-3.3.0-%23CC0000.svg?style=for-the-badge&logo=ruby&logoColor=white"/>
  </a>
  <a href="https://rubyonrails.org/">
    <img src="https://img.shields.io/badge/Ruby%20On%20Rails%20-7.1.3.2-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white"/>
  </a>
  <a href="https://www.sqlite.org/">
    <img src="https://img.shields.io/badge/sqlite-3.37.2-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white">
  </a>
  <a href="https://tailwindcss.com/">
    <img src="https://img.shields.io/badge/tailwindcss-3.4.3-%2338B2AC.svg?style=for-the-badge&logo=tailwind-css&logoColor=white">
  </a>
</p>

## Project development
Most of this application design was based on **<a href="https://www.figma.com/file/JRFN3FpdOcjFWxi0281MDZ/Untitled?type=design&node-id=0-1&mode=design">this Figma project</a>**, it is an old e-commerce design that was made for a freelance and is obsolete as the project was cancelled.

You can check it live at **<a href="https://cade-buffet.up.railway.app/">Cadê Buffet? - Railway</a>**

There is also a simpler <a href="https://vuejs.org/">VueJS</a> app version at **<a href="https://zutin.github.io/">Cadê Buffet? LITE</a>**

A few Ruby gems were used:

- <a href="https://github.com/heartcombo/devise">Devise</a> for authentication
- <a href="https://github.com/fnando/cpf_cnpj/">CPF_CNPJ</a> for CPF/CNPJ validations
- <a href="https://github.com/rails/tailwindcss-rails">Tailwind CSS for Rails</a> for styling
- <a href="https://github.com/rspec/rspec-rails">RSpec</a> for tests/specs
- <a href="https://github.com/teamcapybara/capybara">Capybara</a> for web tests

## Requirements

To run the application, you need to install **Ruby ~> 3.3.0** and **Rails ~> 7.1.3**

## Installation

1. Clone this repository to your local machine:

```bash
git clone https://github.com/zutin/treinadev-cade-buffet.git
```

2. Navigate to the project directory:

```bash
cd treinadev-cade-buffet
```

3. Install the project dependencies:

```bash
bundle install
```

4. Build Tailwind CSS files:

```bash
rails tailwindcss:install
```

5. Run the database migrations:

```bash
rails db:migrate
```
* **(OPTIONAL)** You can also run the database seeds for dummy data

```bash
rails db:seed
```

6. Start local server:

```bash
rails server
```

7. Access the application at:

```bash
http://localhost:3000
```

It is **highly recommended** to run the application tests using *RSpec* after installing so you can make sure everything is working fine.

## How to run tests/specs

You can run tests by navigating to the project folder:
```bash
cd treinadev-cade-buffet
```
And using *RSpec* to run all tests:
```bash
rspec
```
### You can also specify which tests RSpec should try by using:<br>
**System tests**
```bash
rspec ./spec/system
```
**Model tests**
```bash
rspec ./spec/models
```
**Request tests**
```bash
rspec ./spec/requests
```

## API Documentation
### Buffets endpoints
##### Buffet attributes
| Attribute | Type | Description |
|:---:|:---:|:---:|
| id | Integer | Buffet unique identification number |
| trading_name | String | Buffet's trading name |
| contact_number | String | Buffet's contact number |
| email | String | Buffet's email |
| address | String | Buffet's full address |
| district | String | Buffet's location district |
| state | String | Buffet's location state code (2 char) |
| city | String | Buffet's location city |
| zipcode | String | Buffet's location zip code |
| description | String | A description for this Buffet |
| payment_methods | String | Accepted payment methods by this Buffet |
| average_rating | Decimal | Buffet's average rating based on its reviews |

### `(GET /api/v1/buffets)` - Returns all active buffets

**HTTP Request**
```bash
http://localhost:3000/api/v1/buffets
```

**Response**
```bash
HTTP/1.0 200 OK
Content-Type: application/json
[
  {
    "id": 1,
    "trading_name": "Buffet Nº 0",
    "contact_number": "(11) 90000-0000",
    "email": "buffet0@contato.com",
    "address": "Rua dos Bobos, 00",
    "district": "Bairro da Igrejinha",
    "state": "SP",
    "city": "São Paulo",
    "zipcode": "09280080",
    "description": "Buffet #0 para testes e amigos",
    "payment_methods": "Pix, Cartão de Débito",
    "average_rating": 0
  },
  {
    "id": 2,
    "trading_name": "Buffet Nº 1",
    "contact_number": "(11) 91000-0000",
    "email": "buffet1@contato.com",
    "address": "Rua dos Bobos, 01",
    "district": "Bairro da Igrejinha",
    "state": "SP",
    "city": "São Paulo",
    "zipcode": "09280081",
    "description": "Buffet #1 para testes e amigos",
    "payment_methods": "Pix, Cartão de Débito",
    "average_rating": 0
  },
  {
    "id": 3,
    "trading_name": "Buffet Nº 2",
    "contact_number": "(11) 92000-0000",
    "email": "buffet2@contato.com",
    "address": "Rua dos Bobos, 02",
    "district": "Bairro da Igrejinha",
    "state": "SP",
    "city": "São Paulo",
    "zipcode": "09280082",
    "description": "Buffet #2 para testes e amigos",
    "payment_methods": "Pix, Cartão de Débito",
    "average_rating": 0
  }
]
```

### `(GET /api/v1/buffets/{:id})` - Returns a specific buffet

**HTTP Request**
```bash
http://localhost:3000/api/v1/buffets/1
```

**Response**
```bash
HTTP/1.0 200 OK
Content-Type: application/json
{
  "id": 1,
  "trading_name": "Buffet Nº 0",
  "contact_number": "(11) 90000-0000",
  "email": "buffet0@contato.com",
  "address": "Rua dos Bobos, 00",
  "district": "Bairro da Igrejinha",
  "state": "SP",
  "city": "São Paulo",
  "zipcode": "09280080",
  "description": "Buffet #0 para testes e amigos",
  "payment_methods": "Pix, Cartão de Débito",
  "average_rating": 0
}
```

### Events endpoints

##### Event attributes
| Attribute | Type | Description |
|:---:|:---:|:---:|
| id | Integer | Event unique identification number |
| name | String | Event's name |
| description | String | A description for this event |
| minimum_participants | Integer | Minimum participants required for this event |
| maximum_participants | Integer | Maximum participants allowed for this event |
| default_duration | Integer | Event's default duration (in minutes) |
| menu | String | Event's food menu |
| alcoholic_drinks | boolean | Does the event allow alcoholic drinks? |
| decorations | boolean | Does the event include decorations? |
| valet_service | boolean | Does the event include valet service? |
| can_change_location | boolean | Can you change the event location? |

### `(GET /api/v1/buffets/{:id}/events)` - Returns all events that belongs to a specific buffet

**HTTP Request**
```bash
http://localhost:3000/api/v1/buffets/1/events
```

**Response**
```bash
HTTP/1.0 200 OK
Content-Type: application/json
[
  {
    "id": 1,
    "name": "Festa de 20 anos",
    "description": "Super evento do buffet 0",
    "minimum_participants": 10,
    "maximum_participants": 20,
    "default_duration": 60,
    "menu": "Arroz, feijão, batata",
    "alcoholic_drinks": true,
    "decorations": false,
    "valet_service": true,
    "can_change_location": false
  },
  {
    "id": 2,
    "name": "Festa de 21 anos",
    "description": "Super evento do buffet 1",
    "minimum_participants": 20,
    "maximum_participants": 40,
    "default_duration": 120,
    "menu": "Arroz, feijão, batata",
    "alcoholic_drinks": true,
    "decorations": false,
    "valet_service": true,
    "can_change_location": false
  },
]
```

### `(GET /api/v1/events/{:id}?date=yyyy-mm-dd&guests=value)` - Checks if an event is available for hiring at a specific date, if so, it returns the value according to the guests count.

**HTTP Request**
```bash
http://localhost:3000/api/v1/events/1?date=2024-12-16&guests=10
```

**Response**
```bash
HTTP/1.0 200 OK
Content-Type: application/json
{
  "available": true,
  "estimated_value": 100
}
```
It may also be *"available": false*
```bash
HTTP/1.0 200 OK
Content-Type: application/json
{
  "available": false,
  "message": 'ERRO - Não disponível'
}
```

## Author
This project was made by *<a href="https://github.com/zutin">Gian Lucca</a>* during the Crash Course phase in **TreinaDev 12 by Campus Code**.