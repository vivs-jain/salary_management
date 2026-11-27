
# ==========================================
# ACME Salary Management - Initial Seed Data
# ==========================================

ActiveRecord::Base.transaction do

  # ----------------------------------------
  # 1. Create Permissions
  # ----------------------------------------

  permission_definitions = [
    {
      module_name: "dashboard",
      action: "view",
      description: "View application dashboard"
    },
    {
      module_name: "users",
      action: "view",
      description: "View application users"
    },
    {
      module_name: "users",
      action: "create",
      description: "Create application users"
    },
    {
      module_name: "users",
      action: "update",
      description: "Update application users"
    },
    {
      module_name: "users",
      action: "deactivate",
      description: "Deactivate application users"
    },
    {
      module_name: "roles",
      action: "view",
      description: "View application roles"
    },
    {
      module_name: "roles",
      action: "create",
      description: "Create application roles"
    },
    {
      module_name: "roles",
      action: "update",
      description: "Update application roles"
    },
    {
      module_name: "roles",
      action: "assign",
      description: "Assign roles to users"
    },
    {
      module_name: "permissions",
      action: "view",
      description: "View application permissions"
    }
  ]

  permissions = {}

  permission_definitions.each do |definition|
    module_name = definition[:module_name]
    action = definition[:action]

    permission = Permission.find_or_initialize_by(
      module_name: module_name,
      action: action
    )

    permission.name = "#{module_name}.#{action}"
    permission.description = definition[:description]
    permission.save!

    permissions[permission.name] = permission
  end

  # ----------------------------------------
  # 2. Create Roles
  # ----------------------------------------

  role_definitions = {
    "super admin" => "Complete application administration",
    "hr admin" => "Human resource and user management",
    "payroll manager" => "Payroll management",
    "finance manager" => "Financial management and reporting",
    "employee" => "Employee self-service access"
  }

  roles = {}

  role_definitions.each do |name, description|
    role = Role.find_or_initialize_by(name: name)

    role.description = description
    role.active = true
    role.save!

    roles[name] = role
  end

  # ----------------------------------------
  # 3. Define Role Permissions
  # ----------------------------------------

  role_permission_mapping = {
    "super admin" => permissions.keys,

    "hr admin" => [
      "dashboard.view",
      "users.view",
      "users.create",
      "users.update",
      "users.deactivate",
      "roles.view"
    ],

    "payroll manager" => [
      "dashboard.view"
    ],

    "finance manager" => [
      "dashboard.view"
    ],

    "employee" => [
      "dashboard.view"
    ]
  }

  # ----------------------------------------
  # 4. Assign Permissions to Roles
  # ----------------------------------------

  role_permission_mapping.each do |role_name, permission_names|
    role = roles.fetch(role_name)

    permission_names.each do |permission_name|
      permission = permissions.fetch(permission_name)

      role.role_permissions.find_or_create_by!(
        permission: permission
      )
    end
  end

  # ----------------------------------------
  # 5. Assign Super Admin Role
  # ----------------------------------------

  admin_email = ENV["ADMIN_EMAIL"]&.strip&.downcase

  if admin_email.present?
    admin_user = User.find_by!(email: admin_email)

    admin_user.user_roles.find_or_create_by!(
      role: roles.fetch("super admin")
    )

    puts "Super Admin assigned to #{admin_email}"
  else
    puts "No administrator assigned."
    puts "Set ADMIN_EMAIL to assign the initial Super Admin."
  end

  puts "Project initial seed data completed successfully."

end
