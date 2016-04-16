# How to create a Selfie Taker iOS app with Syncano

## Create new XCode project

Start from creating a new empty XCode project. Open XCode, and from file menu select `File -> New -> Project`

![New XCode project](NewProject.jpg)

Choose `Single View Application` and type product name (e.g. `SelfieTaker`). Make sure app language is set to `Swift` and click `Next`. Select a folder where your project should be created and and confirm with `Create` button.

Run your app, either by using run button, or by key Command-R key combination.

![Run XCode project](RunProject.jpg)

If your run starts and you can see empty iPhone screen - all went fine so far. 

![Empty iPhone](iPhoneEmpty.jpg)

You just launched your first (?) iOS App. Now, lets make it do something useful!

## Add User Interface

First, we will add a top bar to our app, and prepare it to be able to navigate between screens. 

On the left menu, choose `Main.storyboard` file.

![Open Storyboard](SelectStoryboard.jpg)

Doing so, will open UI Editor (Interface Builder). From there, find on the right side menu with UI elements and drag and drop to our storyboard element called `Navigation Controller`.

![Add Navigation Controller](AddNavigationController.jpg)

You will see two new controllers on your storyboard. From them, select the second one and remove it. 
Hold down `Control` button and drag and drop your mouse cursor from the the remaining `Navigation Controller View` to our original view.
From contextual menu that appears, select `rootViewController`.

![Add root view controller](AddRootViewController.jpg)

Select again navigation controller, and in options mark option `Is Initial View Controller`. This will tell XCode that it should be the initial screen showed to user when he launched the app.
Navigation Controller by itself doesn't define any UI elements - it's just a container for other view controllers. The root view controller we previously connected to it just means it will be the base view controller shown when app launches.

While in options, make sure to also select `Top Bar` style to be `Opaque Navigation Bar`. This will help us prevent photos being covered by the top bar.

![Navigation Controller Settings](NavigationControllerSettings.jpg) 

Now we need to add some UI controllers to our main view. Drag and drop `Image View` on it. Make sure it fills the whole screen and set up proper constraints.
By setting constraints, we tell iOS how to size our view on different devices - right we just want our view to fill the whole screen, regardless of device size.

![Add Image View](ImageView.jpg)

Change view mode in the right menu to `Aspect Fit` - this way we tell iOS how to display images in our view, if their ratio is different than the one of our screen. Feel free to play with it, and change between different settings later on, to see how it works.

![Set to Aspect Fit](AspectFit.jpg)

Add some button to our view. Find `Bar Button Item` element and drag them to our top bar.

![Add Bar Buttons](BarButtons_1.jpg)

Now, change their names and/or icons. Click on each item on left menu and choose icons and names for them.
My settings for them were:

* System Icon - `Camera`
* System Icon - `Trash`
* Title - `Send`
* Title `All Selfies`

![Set up Bar Buttons](BarButtons_2.jpg)

Open Assistant Editor mode - we will connect our newly added buttons to functions that will be called everytime buttons are pressed.

![Add functions](AssistantEditor.jpg)

Make sure the code editor opened `ViewController.swift` file, as on the screen above.

Holding down control button, drag and drop our image view to the code section. On the assistant screen, choose 

* connectin - `Outlet`
* name - `imageView`
* type - `UIImageView`
* storage - `weak`

![Add image view to code](AddImageView.jpg)

We just connected image view to our code - from now on, we will be able to manipulate it by coding. 

Now we need to do the same for our buttons. 

Hold down `control` button on your keyboard, click on each button item and try to drag and drop it to the code area, inside your class.
Menu will appear asking your to set up the connection between buttons and code.
Select `Action` connection type, for name type:

* `cameraPressed` (for 1st button)
* `trashPressed` (for 2nd button)
* `sendPressed` (for 3rd button)  
* `allSelfiesPressed` (for 4th button)

As type choose `UIBarButtonItem`

![Add functions](AddFunctions.jpg)

Ok, one last thing to add to our user interface. Add `Collection View Controller` to the storyboard. 
Holding down `control` button, drag and drop mouse cursor from `All Selfies` button to `Collection View Controller` and choose `Show`. By doing so, we tell XCode that we want to show this new controller, after `All Selfies` button is pressed.

Click on your `Collection view`, and in settings change its backround color to white.

![Set collection view background 1](CollectionViewColor_1.jpg)

![Set collection view background 2](CollectionViewColor_2.jpg)

### Run!

Now you can run your project. You should see in iPhone Simulator (or on your phone) user interface looking exactly like we defined it, with buttons on the left not doing anything yet. If you press `All Selfies` it should take you to another empty screen, where later we will list all our selfies.

## Add some code

Finally time to do some real coding :)

Choose `ViewController.swift` from menu on the left, and hide Assistant Editor if you haven't done so yet.

![Start Coding](StartCoding.jpg)

### Image Picker / Camera

Copy and paste this code, and replace your `cameraPressed` function with it.  

```swift
    @IBAction func cameraPressed(sender: AnyObject) {
        //UIImagePickerController is a system controller that allows browsing images or taking new ones
        let imagePicker = UIImagePickerController()
        
        //defines what is the source of images - device's photo album, or camera
        imagePicker.sourceType = .SavedPhotosAlbum
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            //camera can be either .Front or .Rear
            imagePicker.cameraDevice = .Front
            //do we want to capture photos or videos
            imagePicker.cameraCaptureMode = .Photo
        }
        //should we allow editing photos after they were taken
        imagePicker.allowsEditing = false
        //which class will be notified when image is taken. `self` means class you're currently in
        imagePicker.delegate = self
        //call this method to present any view controller on screen - here, we show the image picker
        self.presentViewController(imagePicker, animated: true, completion: nil);
    }
```

Comments in code should help to understand what the code does. In short - it creates an instance of `UIImagePickerController` object - it's a controller provided by iOS and it let you get images either from Saved Photos or from your device's camera.

What's important to know - iOS Simulator doesn't offer Camera as source of images - if you choose Camera and run your app in Simulator, it will crash. That's why we first ask what sources are available, and set it to Camera only if we run our app on device.

Add following code at the bottom of your `ViewController.swift` file.

```swift
// MARK: UIImagePickerControllerDelegate
// UIImagePickerControllerDelegate and UINavigationControllerDelegate are protocols - they define set of behaviors
// that your class can or have to implement (methods/functions in protocol can be either required or optional)
// in this class extension we put methods defined in UIImagePickerControllerDelegate protocol
extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //this method will be called every time image picker controller finishes picking new image (from album or camera)
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //we get the original image
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //we add taken picture to our image -- and show it on screen doing so
            self.imageView.image = pickedImage
        }
        //we hide image picker controller (image was taken, we don't need it anymore)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //called when user pressed cancel on image picker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //if user pressed cancel, we want to hide image picker from the screen
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
```
Now, take this function and replace with it `trashPressed` method.

```swift
    @IBAction func trashPressed(sender: AnyObject) {
        //after user pressed trash icon, we want to remove picture from the view
        self.imageView.image = nil
    }
```
