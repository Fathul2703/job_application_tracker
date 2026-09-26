// Small value enums used by applications and interviews. All are stored in
// the database by `name`: never rename a value without a migration.

enum WorkMode {
  onsite('On-site'),
  hybrid('Hybrid'),
  remote('Remote');

  const WorkMode(this.label);
  final String label;
}

enum EmploymentType {
  fullTime('Full-time'),
  partTime('Part-time'),
  contract('Contract'),
  internship('Internship'),
  freelance('Freelance');

  const EmploymentType(this.label);
  final String label;
}

enum SalaryPeriod {
  monthly('per month'),
  yearly('per year');

  const SalaryPeriod(this.label);
  final String label;
}

enum InterviewFormat {
  phone('Phone'),
  video('Video'),
  onsite('On-site');

  const InterviewFormat(this.label);
  final String label;
}

enum InterviewOutcome {
  pending('Pending'),
  passed('Passed'),
  failed('Failed'),
  cancelled('Cancelled');

  const InterviewOutcome(this.label);
  final String label;
}
