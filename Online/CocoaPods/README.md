## Development setup

Once you have gained access, set up the development environment by following:

1. We recommend using `rbenv` to handle `ruby` selection/installation.
   1. Install `rbenv`:
   ```zsh
   brew install rbenv
   ```
   2. Clone the [tomtom-navigation-ios-examples] repository
   ```zsh
   git clone git@github.com:tomtom-international/tomtom-navigation-ios-examples.git
   ```   
   3. Change directory to the related folder of the recently cloned repository and install `ruby` via `rbenv`
   ```zsh
   cd tomtom-navigation-ios-examples/CocoaPods
   rbenv install
   ```
   4. Load `rbenv` to your shell
   ```zsh
   echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
   ```
   Above command assumes that `zsh` is being used. If a different shell is being used, then you can find 
   commands for most common shells in [rbenv documentation].

   5. Update `bundler`
   ```zsh
   gem install bundler
   ```
   6. ***Reload*** your shell so the `rbenv` can extend `PATH` accordingly.

2. Install project's `gem` dependencies via `bundler`
   ```zsh
   bundle install
   ```

3. Add a reference to the [CocoaPods] private repository:
   ```zsh
   bundle exec pod repo-art add tomtom-sdk-cocoapods "https://repositories.tomtom.com/artifactory/api/pods/cocoapods"
   ```

4. Install the dependencies by executing the following command in **the project folder**.
    ```zsh
    bundle exec pod install
    ```

5. To update the SDK version, run the command:
    ```zsh
    bundle exec pod repo-art update tomtom-sdk-cocoapods
    ```
6. Open the project’s `xcworkspace` and start developing your awesome application.

[CocoaPods]: (https://guides.cocoapods.org/using/getting-started.html)
[rbenv documentation]: https://github.com/rbenv/rbenv#readme
[tomtom-navigation-ios-examples]: https://github.com/tomtom-international/tomtom-navigation-ios-examples