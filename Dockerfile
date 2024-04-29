FROM squidfunk/mkdocs-material

RUN mkdir /docs/docs
ADD README.md /docs/README.md
ADD docs/mkdocs.yml /docs/mkdocs.yml

WORKDIR /docs
