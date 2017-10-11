FROM ruby:2.3.3

ENV GEM_HOME /home/gems/mygem
RUN mkdir -p $GEM_HOME
WORKDIR $GEM_HOME
COPY . $GEM_HOME
RUN bundle install
