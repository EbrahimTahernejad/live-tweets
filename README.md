# Live Tweet

## Specification

- MVVM
- Uses a router system written from scratch
- Dependency Injection

## Initialization

To initialize this project, you need to create a copy of the [Main.template.xcconfig](Live%20Tweets/Resources/Configs/Main.template.xcconfig) file, located in:

`Live Tweets/Resources/Configs/`

Name it Main.xcconfig and fill in the requires values

### Values

- `TWITTER_BEARER_TOKEN`: The bearer token provided by twitter in [developer dashboard](https://developer.twitter.com/en/portal/dashboard)
- `TWITTER_BASE_URL`: Twitter's base url. Don't change (should end with trailing `/`)

## Project Structure

### Views

Every view should conform to `RootViewProtocol`

Just for ease We've added a base class for `UIView` called `RootView`, and for `UITableViewCell` called `RootCellView`. It can be done for other types of `UIView` as well.

## View Models

Every view model should conform to `BaseViewModelProtocol`

There is a class called `BaseViewModel` which can be used as a base for view models

### Input and output logic

Each view model has a input object and output object, there are no real reasons for this, just thought it would be a good extension to view model to divide some of its work

### `inject` and `dependencies`

Each view model should have a static variable called `inject`, which selects the dependencies the view model needs.

You can see that inside `BaseViewModel` it's used as:

```
class var inject: DependencyOptions {
  return [.router]
}
```

## Dependency Injection

Dependencies conform to `ServiceProtocol`

To add a new dependency, you'll need to modify each object inside the file `Dependencies.swift`, then add it to the injection logic in `ViewProvider`'s `injectDependencies`.

Then provide and instance of them wherever the `ViewProvider` is created (here, we have it in `SceneDelegate`)

## View Provider

`ViewProvider` is the class which creates views and injects dependencies in them.

It is automatocally injected into all views.

The `provide` function should be used to create an instance of a view.

## Router

The router manages routing system of our app.

It can both push views into top `NavigationController`, create a new navigation controller and present it with the provided view as its root, or go back/dismiss(if forced or top navigation has only one controller in it)


