# Step 1: Install the application (this happens unconditionally)
echo "Installing the application..."
# Your installation commands here

# Step 2: Ask whether to apply Omakub dotfiles
if gum confirm "Would you like to apply Omakub configuration for this application?"; then
    # Apply Omakub settings
    echo "Applying Omakub settings..."
    # Your dotfiles/configuration commands here
else
    echo "Skipping Omakub configuration."
fi
