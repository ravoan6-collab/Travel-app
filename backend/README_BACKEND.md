# Travel App Backend (Laravel + MySQL)

Base URL (local): `http://localhost:8000/api`
Always send the header `Accept: application/json`.
Protected routes also need `Authorization: Bearer <token>` (token comes from register/login).

Demo user after seeding: `test@example.com` / `password123`

## Auth
| Method | Endpoint | Body | Auth |
|---|---|---|---|
| POST | /register | name, email, password (min 6) | no |
| POST | /login | email, password | no |
| GET | /me | - | yes |
| POST | /logout | - | yes |

## Hotels, Places, Restaurants
| Method | Endpoint | Notes | Auth |
|---|---|---|---|
| GET | /hotels, /places, /restaurants | `?search=`, `?city=`, `?per_page=` (paginated, list is in `data`) | no |
| GET | /hotels/{id} (same for places, restaurants) | includes `reviews_avg_rating`, `reviews_count` | no |
| POST / PUT / DELETE | /hotels, /places, /restaurants (+ `/{id}`) | create, update, delete | yes |

## Itineraries (own data only)
| Method | Endpoint | Body |
|---|---|---|
| GET | /itineraries | - |
| POST | /itineraries | title, destination, start_date, end_date, notes, items[] (day, time, title, notes) |
| GET | /itineraries/{id} | - |
| PUT | /itineraries/{id} | any field; sending `items` replaces all items |
| DELETE | /itineraries/{id} | - |

## Bookings (own data only)
| Method | Endpoint | Body |
|---|---|---|
| GET | /bookings | - |
| POST | /bookings | hotel_id, check_in, check_out, guests (total price is calculated) |
| GET | /bookings/{id} | - |
| DELETE | /bookings/{id} | cancels the booking (status becomes `cancelled`) |

## Reviews
| Method | Endpoint | Body | Auth |
|---|---|---|---|
| GET | /reviews?type=hotel&id=1 | type is hotel, place or restaurant | no |
| POST | /reviews | type, id, rating (1-5), comment (one review per user per item) | yes |
| DELETE | /reviews/{id} | own review only | yes |
