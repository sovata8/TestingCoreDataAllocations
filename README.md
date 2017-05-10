# TestingCoreDataAllocations

## What is this?
This is a sample project to help ask questions about Core Data memory allocations. 

## The question

### tl;dr
When creating and fetching Core Data objects, there are some contradicting and somewhat confusing memory allocations reports in `Debug Memory Graph` and `Instruments`.


### Environment
`Xcode 8` `Swift 3` `iOS 10`


-------------------------------

### App Setup
I have the following simple app setup.

- Core Data model with one entity - `Book` (which auto-generates a `NSManagedObject` subclass with the same name as per default behaviour of Xcode).
- Two buttons - `create book` and `list all books` that do what you would expect.

-------------------------------

### App Run Steps A

1. Run the app 
2. Press `create book` once.
3. In `Debug Memory Graph` (the new Xcode 8 feature, and remember after done inspecting, to press "Continue program execution")

```
Book (1)
Book_Book_ (1)
```

(the stuff in brackets is the number of instances)

4. Press `create book` two more times.
5. In `Debug Memory Graph`:

```
Book (1)
Book_Book_ (3)
```

#### Observations
In the `Debug Memory Graph` context, `Book_Book_` is what refers to instances of our actual `Book` class, whereas `Book` refers to instances of something else, and it doesn't increase when the create more books. So maybe it refers to something like an Entity Description or some sort of 'Blueprint' or 'Object Factory'.

-------------------------------

### App Run Steps B

1. Run the app 
2. Press `create book` three times.
3. In `Debug Memory Graph`:

```
Book (1)
Book_Book_ (3)
```

4. Press `list all books` once
5. In `Debug Memory Graph`:

```
Book (6)
Book_Book_ (3)
```

#### Observations
The `Debug Memory Graph > Book` increased from 1 to 6.

6. Press `list all books` more (once or many times more)

7. No change in `Debug Memory Graph`

--------------

### Instruments app

I re-did the `App Run Steps A` and `B`, but this time instead of looking at the `Debug Memory Graph`, I was using the `Instruments` app (Xcode > Product > Profile) with the `Allocations` profiling template (which shows `All Heap & Anonymous VM`). I was looking into `Details > Statistics > Allocation Summary > # Total` and in the filter I put the word `Book`.

With `App Run Steps A` I saw the same things I saw as when using the `Debug Memory Graph`. (`Book` - 1, `Book_Book` - 3)
With `App Run Steps B`, pressing `list all books` did not change anything. All allocations count remained the same (`Book` - 1, `Book_Book` - 3).

#### Observations
While the `Debug Memory Graph` shows the `Book` increasing from `1` to `6` when pressing `list all books`, in the `Instruments` app `Book` remained `1`.


## Questions
- What does this `Debug Memory Graph > Book` refer to? Is it related to some new features of Core Data (WWDC 2016 talked about "Query generations" for example)
- Why do `Debug Memory Graph` and `Instruments` show different things? Which one is correct?


##### Additional possibly related observations
- The instruments app shows the `Responsible Caller` to be:
  - For `Book` - `PFPlaceHolderSingleton`
  - For `Book_Book_` - `PFAllocateObject`

- Sometimes people report differences between Instruments and Xcode that turn out to be because Xcode Run action uses Debug configuration, whereas Instruments uses Release configuration. I tried with both being Debug or both being Release, and the results were the same as described above.

##### Footnote on known bad practices in the sample code
Since this is just a sample project, it does some things in a way not appropriate for production code: for example keeping core data stack in AppDelegate, forced optional unwrapping and forced `try` statements without `catch` logic.