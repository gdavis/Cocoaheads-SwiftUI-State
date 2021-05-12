# Swift UI State Management

This document cataloges my experiences with properly managing state with SwiftUI, as presented at Cocoaheads in May 2021. The content and example app in this repo is from my original documentation of the problem while working on a client app that made heavy use of lazy stacks, `@StateObject`, and issues we ran into properly storing view models in memory. 

## Storing state for Child View Models
SwiftUI is all about state, and maintaining that state can be rather difficult when you have more than a few properties stored as @State for your view. It is common practice to use a view model to store the state outside of the view, since our views are constantly recreated as our state changes. Keeping what state you want in memory can provide a challenge, much more so than it may seem at first glance.

With SwiftUI 2, using @StateObject will keep a view model from being recreated with each rendering of a view's body. If the parent view is creating the view model, and then passing that down to the child view, that view model will also be recreated with each rendering of that parent view body.

```swift
struct ParentView: View {
  var body: some View {
    let viewModel = MyChildViewModel(title: "Hello World")
    ChildView(viewModel: viewModel)
  }
}
```
The example above will recreate the `MyChildViewModel` with each rendering of the `ParentView`, which can be a lot. Anytime its own state changes, we'll redraw the body, effectively deallocating and recreating the `MyChildViewModel` and losing all the previous state.

The fix is to have the child view create its own view model. If the view model has no parameters that need to be provided, it can be created with a simple declaration in the view's struct. 

```swift
struct ChildView: View {
  @StateObject var viewModel = MyChildViewModel()
}
```
However, if parameters need to be provided, we need to invoke the init method of the state object, and perform the creation of the view model within the autoclosure of the StateObject's init. This ensures that our view model is only created once, as the StateObject will only call the autoclosure once for the lifetime of the view. 

```swift
struct ChildView: View {
  @StateObject var viewModel: MyChildViewModel

  init(title: String) {
    self._viewModel = StateObject(wrappedValue: 
    		MyChildViewModel(string: string))
  }
}
```

This works well until this view is placed within a LazyH/VStack; where we will need to more tightly control state, as described in the next section.

## LazyH/VStacks
These views seems to break all state management we come to expect when using @StateObject for views rendered within the stack. This is likely an optimization when building hundreds or thousands of views within a stack, and to prevent memory from filling up much more than we need to dislay. These stacks do not maintain the same state consistency that other View objects do, and more heavy-handed state ownership is required. 

If we have a case where we have 20 or so views that need to display that all have their view models with data being loaded by those view models, we would like that data to be cached so each time a view is drawn by the lazy stack, we don't have to totally recreate the view models driving the content for those views. 

For example, if you have a view comprised of LazyHStacks or LazyVStacks, any use of @StateObject to store a view model within those stack's views will NOT be maintained between renderings of the stack. This leads us to have to manage ownership of the view models elsewhere, such as in a cache within another object, such as the parent's view model, in order to cache their data between view renderings. 

In this scenario, instead of having each child view create its own view model, we would use a find-or-create pattern to store those view models within another view's view model, or another persistently stored object.

```swift
class ParentViewModel: ObservableObject {
  var childViewModelCache: [Identifier: ChildViewModel] = []

  func childViewModel(for identifier: Identifier) -> ChildViewModel {
    if let existingViewModel = childViewModelCache[identifier] {
      return existingViewModel
    }
  
    let newViewModel = ChildViewModel()
    childViewModelCache[identifier] = newViewModel
    return newViewModel
  }
}
```
```swift
struct ParentView: View {
  @StateObject var viewModel = ParentViewModel()

  var body: some View {
    LazyHStack {
      ForEach(childData) { data in
        ChildView(viewModel: viewModel.childViewModel(for: data.id)
      }
    }
  }
}
```
The above example has the parent view model caching each child view's view model so that data can persist between displays of the `ChildView`. We'll also need to take into consideration our memory footprint doing this, and may need to clear the cache when we receive a memory warning. This however will make it so images/network requests, etc that are performed by the view model do not repeat when objects are scrolled onto the screen after the inital load. 

## Redrawing Lazy Stacks
Imagine a scenario where a lazy stack draws content that changes size after its own initial content has loaded. A lazy stack will not 
