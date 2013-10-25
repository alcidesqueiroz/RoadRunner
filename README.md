RoadRunner
=====

What is?
--------

RoadRunner is a simple, but powerful, live reload tool totally written in Ruby. Though RoadRunner was made in Ruby, it is language-agnostic, in simple words: you can use RoadRunner with ANY language or platform (or operating system) in your back-end. You just need ruby installed.


Usage
--------------------
1) Run:
```ruby
sudo gem install roadrunner
``` 

2) Create a roadrunner.yml file in the root folder of your project. (you can copy the roadrunner.sample.yml file in this repo).
```yaml
config:
  polling_interval: 0.1
  change_check_strategy: modification_time #You also can use 'checksum'
  port: 9876
  files: [
           ["/webroot/css/main.css", "/yourapp/css/main.css"],
           "/equivalent/path.css"
         ]
```
If the relative path to your css file to be monitored in your project folder structure is equal to its URL in web server, you just have to add this to the "files" collection. 

```yaml
  files: [
           "/equivalent/path.css",
           ...
         ]
```

But if the paths are different, you can map it easily:
```yaml
  files: [
           ["/relative/path/to/some/css-file.css", "/relative/path/in/your/web-server.css"],
           ...
         ]
```
3) Copy roadrunner-0.1.0.debug.js to some place of your application and add a reference to it in the head tag of your layout/master page/template.
```javascript
<script src="/path/to/roadrunner-0.1.0.debug.js"></script>
```
4)Open a terminal, "cd" to your project root folder (where roadrunner.yml is located) and run: 
```
roadrunner
```

License
-------
This code is free to use under the terms of the MIT license
