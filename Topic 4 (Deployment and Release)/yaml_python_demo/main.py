import yaml

with open('test.yml') as file:
    obj_1 = yaml.safe_load(file.read())

print(obj_1)
