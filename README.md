# mentoring
Project for mentoring session

This project is intended for the mentoring session.

Contains a sample of a startup flow used in an enterprise app. Lots of code has been commented out/removed in order to avoid making a licensed software to be shared publicly.

The main complexities of the start up flow is that we need to perform actions in a specific order and each action is ablocker for the next one and its result decide the following one.
Actions might be performing APIs or pushing a page, or perfoming an animation.

In order to avoid calling our APIs endpoints each API has been substituted with a stubbed result dispatched over some milliseconds.

