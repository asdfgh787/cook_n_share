import cv2
from flask import Flask, send_file, jsonify, request, send_from_directory
from flask_cors import CORS
import json
import io
import os
import PIL.Image as Image
import numpy as np
import matplotlib.pyplot as plt
from werkzeug.serving import WSGIRequestHandler
import base64

app = Flask(__name__)
CORS(app)
recepies = {
  "recipes":
  [
    {
      "image": "https://img.cocinarico.es/2019-12/pizza-margherita-1.jpg",
      "name": "Pizza Margarita",
      "user": "@BradPittOficial",
      "ingredients": ["112-inch round of pizza dough",
        "3 tablespoons tomato sauce",
        "Extra-virgin olive oil",
        "2 3/4 ounces fresh mozzarella",
        "4 to 5 basil leaves, roughly torn"],
      "likes": 234,
      "steps":
      [
        "Place a pizza stone or tiles on the middle rack of your oven and turn heat to its highest setting. Let it heat for at least an hour.",
        "Put the sauce in the center of the stretched dough and use the back of a spoon to spread it evenly across the surface, stopping approximately ½ inch from the edges.",
        "Drizzle a little olive oil over the pie. Break the cheese into large pieces and place these gently on the sauce. Scatter basil leaves over the top.",
        "Using a pizza peel, pick up the pie and slide it onto the heated stone or tiles in the oven. Bake until the crust is golden brown and the cheese is bubbling, approximately 4 to 8 minutes."
      ],
      "allergens": ["Gluten", "Milk", "Wheat"]
    },
    {
      "image": "https://simply-delicious-food.com/wp-content/uploads/2020/05/Crispy-sesame-chicken-4.jpg",
      "name": "Crispy Sesame Chicken with a Sticky Asian Sauce",
      "user": "@Chayanne",
      "ingredients":
      [
        "5 tbsp Vegetable oil",
        "2 eggs - lightly beaten",
        "3 tbsp cornflour (cornstarch)",
        "10 tbsp plain (all-purpose) flour",
        "1/2 tsp salt",
        "1/2 tsp pepper",
        "1/2 tsp garlic salt",
        "2 tsp paprika",
        "3 chicken breast fillets - chopped into bite-size chunks"
      ],
      "likes": 342,
      "steps":
      [
        "Heat the oil in a wok or large frying pan until very hot.",
        "Whilst the oil is heating, place the egg in one shallow bowl and the cornflour in another shallow bowl. Add the flour, salt, pepper, garlic salt and paprika to another shallow bowl and mix together.",
        "Dredge the chicken in the cornflour, then dip in the egg (make sure all of the chicken is covered in egg wash), and finally dredge it in the seasoned flour. Add to the wok and cook on a high heat for 6-7 minutes, turning two or three times during cooking, until well browned. You may need to cook in two batches (I find I can do it in one batch so long as it's no more than 3 chicken breasts). Remove from the pan and place in a bowl lined with kitchen towels.",
        "Add all of the sauce ingredients to the hot wok, stir and bubble on a high heat until the sauce reduces by about a third (should take 2-3 minutes). Add the chicken back in and toss in the sauce to coat. Cook for 1-2 minutes.",
        "Turn off the heat and divide between four bowls. Serve with boiled rice and top with sesame seeds and spring onions."
      ],
      "allergens": ["Gluten/Wheat", "Eggs", "Sesame Seeds", "Soy"]
    },
    {
      "image": "https://www.cookingclassy.com/wp-content/uploads/2021/05/italian-pasta-salad-15.jpg",
      "name": "Pasta Salad with Italian Dressing",
      "user": "@martagil",
      "ingredients":
      [
        "1.1 lb (500g) dried pasta shapes - (I use fusilli for this recipe)",
        "1 lb (450g) cherry tomatoes - sliced in half – I like to use rainbow tomatoes, but you can use regular",
        "10 1/2 oz (300g) mini mozzarella balls/pearls - sliced in half",
        "4 baby cucumbers - or 1 regular cucumber, sliced",
        "1 large red onion - peeled and sliced",
        "2 cups (65g) fresh peashoots - (you can replace with lambs lettuce, watercress or mild rocket)",
        "1 large bunch fresh parsley - chopped"
      ],
      "likes": 234,
      "steps":
      [
        "Cook the pasta as per the pack instructions. Drain and run under cold water to cool and prevent from sticking.",
        "Whilst the pasta is cooking, make the Italian style salad dressing by mixing together all of the dressing ingredients in a jug or jar until combined.",
        "Transfer the cooked pasta to a large serving bowl. Add in the tomatoes, mozzarella, cucumber, red onion, peashoots and parsley.",
        "Drizzle over half of the dressing and toss everything together.",
        "Serve the pasta salad with the remaining dressing."
      ],
      "allergens": ["Gluten"]
    },
      {
      "image": "https://2trendies.com/hero/2023/04/pizzapepperoni.jpg",
      "name": "Pizza Pepperoni",
      "user": "@BradPittOficial",
      "ingredients": ["112-inch round of pizza dough",
        "3 tablespoons tomato sauce",
        "Extra-virgin olive oil",
        "2 3/4 ounces fresh mozzarella",
        "4 to 5 basil leaves, roughly torn",
        "Pepperoni"],
      "likes": 235,
      "steps":
      [
        "Place a pizza stone or tiles on the middle rack of your oven and turn heat to its highest setting. Let it heat for at least an hour.",
        "Put the sauce in the center of the stretched dough and use the back of a spoon to spread it evenly across the surface, stopping approximately ½ inch from the edges.",
        "Drizzle a little olive oil over the pie. Break the cheese into large pieces and place these gently on the sauce. Scatter basil leaves over the top.",
        "Using a pizza peel, pick up the pie and slide it onto the heated stone or tiles in the oven. Bake until the crust is golden brown and the cheese is bubbling, approximately 4 to 8 minutes."
      ],
      "allergens": ["Gluten", "Milk", "Wheat"]
    },
  ]

}

@app.route('/returnImage', methods=['GET', 'POST'])
def returnImage():
    global recepies
    content = request.get_json()
    resposta = None
    if bool(content):
        resposta = content['name']
    ret = {'recipes': []}
    if resposta != None:
        for i in range(len(recepies['recipes'])):
            names = recepies['recipes'][i]['name'].split(' ')
            names = [x.lower() for x in names]
            if resposta in names:
                ret['recipes'].append(recepies['recipes'][i])


        response = jsonify(ret)
    else:
        response = jsonify(recepies)

    response.headers.add("Access-Control-Allow-Origin", "*")

    return response

users = {'users' : [{  'alias': '@BradPittOficial',
                       'name': 'Brad Pitt',
                       'following':'1',
                       'followers':'4323122' ,
                       'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Brad_Pitt_2019_by_Glenn_Francis.jpg/1200px-Brad_Pitt_2019_by_Glenn_Francis.jpg',
                       'recipes': [{
                          "image": "https://img.cocinarico.es/2019-12/pizza-margherita-1.jpg",
                          "name": "Pizza Margarita",
                          "user": "BradPittOficial",
                          "ingredients": ["112-inch round of pizza dough",
                            "3 tablespoons tomato sauce",
                            "Extra-virgin olive oil",
                            "2 3/4 ounces fresh mozzarella",
                            "4 to 5 basil leaves, roughly torn"],
                          "likes": 234,
                          "steps":
                          [
                            "Place a pizza stone or tiles on the middle rack of your oven and turn heat to its highest setting. Let it heat for at least an hour.",
                            "Put the sauce in the center of the stretched dough and use the back of a spoon to spread it evenly across the surface, stopping approximately ½ inch from the edges.",
                            "Drizzle a little olive oil over the pie. Break the cheese into large pieces and place these gently on the sauce. Scatter basil leaves over the top.",
                            "Using a pizza peel, pick up the pie and slide it onto the heated stone or tiles in the oven. Bake until the crust is golden brown and the cheese is bubbling, approximately 4 to 8 minutes."
                          ],
                          "allergens": ["Gluten", "Milk", "Wheat"]
                        },{
                          "image": "https://2trendies.com/hero/2023/04/pizzapepperoni.jpg",
                          "name": "Pizza Pepperoni",
                          "user": "@BradPittOficial",
                          "ingredients": ["112-inch round of pizza dough",
                            "3 tablespoons tomato sauce",
                            "Extra-virgin olive oil",
                            "2 3/4 ounces fresh mozzarella",
                            "4 to 5 basil leaves, roughly torn"],
                          "likes": 235,
                          "steps":
                          [
                            "Place a pizza stone or tiles on the middle rack of your oven and turn heat to its highest setting. Let it heat for at least an hour.",
                            "Put the sauce in the center of the stretched dough and use the back of a spoon to spread it evenly across the surface, stopping approximately ½ inch from the edges.",
                            "Drizzle a little olive oil over the pie. Break the cheese into large pieces and place these gently on the sauce. Scatter basil leaves over the top.",
                            "Using a pizza peel, pick up the pie and slide it onto the heated stone or tiles in the oven. Bake until the crust is golden brown and the cheese is bubbling, approximately 4 to 8 minutes."
                          ],
                          "allergens": ["Gluten", "Milk", "Wheat"]
                        }]},
{  'alias': '@martagil',
   'name': 'Marta Gil',
   'following':'3123',
   'followers':'3221' ,
   'image': 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
   'recipes': [
{
      "image": "https://www.cookingclassy.com/wp-content/uploads/2021/05/italian-pasta-salad-15.jpg",
      "name": "Pasta Salad with Italian Dressing",
      "user": "@martagil",
      "ingredients":
      [
        "1.1 lb (500g) dried pasta shapes - (I use fusilli for this recipe)",
        "1 lb (450g) cherry tomatoes - sliced in half – I like to use rainbow tomatoes, but you can use regular",
        "10 1/2 oz (300g) mini mozzarella balls/pearls - sliced in half",
        "4 baby cucumbers - or 1 regular cucumber, sliced",
        "1 large red onion - peeled and sliced",
        "2 cups (65g) fresh peashoots - (you can replace with lambs lettuce, watercress or mild rocket)",
        "1 large bunch fresh parsley - chopped"
      ],
      "likes": 234,
      "steps":
      [
        "Cook the pasta as per the pack instructions. Drain and run under cold water to cool and prevent from sticking.",
        "Whilst the pasta is cooking, make the Italian style salad dressing by mixing together all of the dressing ingredients in a jug or jar until combined.",
        "Transfer the cooked pasta to a large serving bowl. Add in the tomatoes, mozzarella, cucumber, red onion, peashoots and parsley.",
        "Drizzle over half of the dressing and toss everything together.",
        "Serve the pasta salad with the remaining dressing."
      ],
      "allergens": ["Gluten"]
    }


   ]},

                    {
'alias': '@Chayanne',
   'name': 'Chayanne',
   'following':'423',
   'followers':'53221' ,
   'image': 'https://pbs.twimg.com/media/Em__-nuXYAEKUGD.jpg',
   'recipes':
                        [{
      "image": "https://simply-delicious-food.com/wp-content/uploads/2020/05/Crispy-sesame-chicken-4.jpg",
      "name": "Crispy Sesame Chicken with a Sticky Asian Sauce",
      "user": "@Chayanne",
      "ingredients":
      [
        "5 tbsp Vegetable oil",
        "2 eggs - lightly beaten",
        "3 tbsp cornflour (cornstarch)",
        "10 tbsp plain (all-purpose) flour",
        "1/2 tsp salt",
        "1/2 tsp pepper",
        "1/2 tsp garlic salt",
        "2 tsp paprika",
        "3 chicken breast fillets - chopped into bite-size chunks"
      ],
      "likes": 342,
      "steps":
      [
        "Heat the oil in a wok or large frying pan until very hot.",
        "Whilst the oil is heating, place the egg in one shallow bowl and the cornflour in another shallow bowl. Add the flour, salt, pepper, garlic salt and paprika to another shallow bowl and mix together.",
        "Dredge the chicken in the cornflour, then dip in the egg (make sure all of the chicken is covered in egg wash), and finally dredge it in the seasoned flour. Add to the wok and cook on a high heat for 6-7 minutes, turning two or three times during cooking, until well browned. You may need to cook in two batches (I find I can do it in one batch so long as it's no more than 3 chicken breasts). Remove from the pan and place in a bowl lined with kitchen towels.",
        "Add all of the sauce ingredients to the hot wok, stir and bubble on a high heat until the sauce reduces by about a third (should take 2-3 minutes). Add the chicken back in and toss in the sauce to coat. Cook for 1-2 minutes.",
        "Turn off the heat and divide between four bowls. Serve with boiled rice and top with sesame seeds and spring onions."
      ],
      "allergens": ["Gluten/Wheat", "Eggs", "Sesame Seeds", "Soy"]
    }]}
]}
@app.route('/returnUser', methods=['GET', 'POST'])
def returnUser():
    global users
    content = request.get_json()
    resposta = content['user']
    aux = {}
    for i in range(len(users['users'])):
        name = users['users'][i]['alias']
        if resposta == name:
            aux = [users['users'][i]]
            break
    response = jsonify(user=aux)
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response


if __name__ == '__main__':
    WSGIRequestHandler.protocol_version = "HTTP/1.1"  # s'utilitza per poder tenir una connexió de tipus Keep-Alive
    app.run()
