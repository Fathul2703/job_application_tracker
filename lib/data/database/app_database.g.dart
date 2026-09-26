// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ApplicationsTable extends Applications
    with TableInfo<$ApplicationsTable, ApplicationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApplicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionTitleMeta = const VerificationMeta(
    'positionTitle',
  );
  @override
  late final GeneratedColumn<String> positionTitle = GeneratedColumn<String>(
    'position_title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WorkMode?, String> workMode =
      GeneratedColumn<String>(
        'work_mode',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<WorkMode?>($ApplicationsTable.$converterworkModen);
  @override
  late final GeneratedColumnWithTypeConverter<EmploymentType?, String>
  employmentType =
      GeneratedColumn<String>(
        'employment_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<EmploymentType?>(
        $ApplicationsTable.$converteremploymentTypen,
      );
  static const VerificationMeta _salaryMinMeta = const VerificationMeta(
    'salaryMin',
  );
  @override
  late final GeneratedColumn<int> salaryMin = GeneratedColumn<int>(
    'salary_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _salaryMaxMeta = const VerificationMeta(
    'salaryMax',
  );
  @override
  late final GeneratedColumn<int> salaryMax = GeneratedColumn<int>(
    'salary_max',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _salaryCurrencyMeta = const VerificationMeta(
    'salaryCurrency',
  );
  @override
  late final GeneratedColumn<String> salaryCurrency = GeneratedColumn<String>(
    'salary_currency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('IDR'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SalaryPeriod?, String>
  salaryPeriod = GeneratedColumn<String>(
    'salary_period',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<SalaryPeriod?>($ApplicationsTable.$convertersalaryPeriodn);
  static const VerificationMeta _jobUrlMeta = const VerificationMeta('jobUrl');
  @override
  late final GeneratedColumn<String> jobUrl = GeneratedColumn<String>(
    'job_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ApplicationStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(ApplicationStatus.saved.name),
  ).withConverter<ApplicationStatus>($ApplicationsTable.$converterstatus);
  static const VerificationMeta _appliedAtMeta = const VerificationMeta(
    'appliedAt',
  );
  @override
  late final GeneratedColumn<DateTime> appliedAt = GeneratedColumn<DateTime>(
    'applied_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deadlineAtMeta = const VerificationMeta(
    'deadlineAt',
  );
  @override
  late final GeneratedColumn<DateTime> deadlineAt = GeneratedColumn<DateTime>(
    'deadline_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    companyName,
    positionTitle,
    location,
    workMode,
    employmentType,
    salaryMin,
    salaryMax,
    salaryCurrency,
    salaryPeriod,
    jobUrl,
    status,
    appliedAt,
    deadlineAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'applications';
  @override
  VerificationContext validateIntegrity(
    Insertable<ApplicationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_companyNameMeta);
    }
    if (data.containsKey('position_title')) {
      context.handle(
        _positionTitleMeta,
        positionTitle.isAcceptableOrUnknown(
          data['position_title']!,
          _positionTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_positionTitleMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('salary_min')) {
      context.handle(
        _salaryMinMeta,
        salaryMin.isAcceptableOrUnknown(data['salary_min']!, _salaryMinMeta),
      );
    }
    if (data.containsKey('salary_max')) {
      context.handle(
        _salaryMaxMeta,
        salaryMax.isAcceptableOrUnknown(data['salary_max']!, _salaryMaxMeta),
      );
    }
    if (data.containsKey('salary_currency')) {
      context.handle(
        _salaryCurrencyMeta,
        salaryCurrency.isAcceptableOrUnknown(
          data['salary_currency']!,
          _salaryCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('job_url')) {
      context.handle(
        _jobUrlMeta,
        jobUrl.isAcceptableOrUnknown(data['job_url']!, _jobUrlMeta),
      );
    }
    if (data.containsKey('applied_at')) {
      context.handle(
        _appliedAtMeta,
        appliedAt.isAcceptableOrUnknown(data['applied_at']!, _appliedAtMeta),
      );
    }
    if (data.containsKey('deadline_at')) {
      context.handle(
        _deadlineAtMeta,
        deadlineAt.isAcceptableOrUnknown(data['deadline_at']!, _deadlineAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ApplicationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApplicationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      )!,
      positionTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}position_title'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      workMode: $ApplicationsTable.$converterworkModen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}work_mode'],
        ),
      ),
      employmentType: $ApplicationsTable.$converteremploymentTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}employment_type'],
        ),
      ),
      salaryMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}salary_min'],
      ),
      salaryMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}salary_max'],
      ),
      salaryCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salary_currency'],
      )!,
      salaryPeriod: $ApplicationsTable.$convertersalaryPeriodn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}salary_period'],
        ),
      ),
      jobUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_url'],
      ),
      status: $ApplicationsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      appliedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}applied_at'],
      ),
      deadlineAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ApplicationsTable createAlias(String alias) {
    return $ApplicationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WorkMode, String, String> $converterworkMode =
      const EnumNameConverter<WorkMode>(WorkMode.values);
  static JsonTypeConverter2<WorkMode?, String?, String?> $converterworkModen =
      JsonTypeConverter2.asNullable($converterworkMode);
  static JsonTypeConverter2<EmploymentType, String, String>
  $converteremploymentType = const EnumNameConverter<EmploymentType>(
    EmploymentType.values,
  );
  static JsonTypeConverter2<EmploymentType?, String?, String?>
  $converteremploymentTypen = JsonTypeConverter2.asNullable(
    $converteremploymentType,
  );
  static JsonTypeConverter2<SalaryPeriod, String, String>
  $convertersalaryPeriod = const EnumNameConverter<SalaryPeriod>(
    SalaryPeriod.values,
  );
  static JsonTypeConverter2<SalaryPeriod?, String?, String?>
  $convertersalaryPeriodn = JsonTypeConverter2.asNullable(
    $convertersalaryPeriod,
  );
  static JsonTypeConverter2<ApplicationStatus, String, String>
  $converterstatus = const EnumNameConverter<ApplicationStatus>(
    ApplicationStatus.values,
  );
}

class ApplicationRow extends DataClass implements Insertable<ApplicationRow> {
  final int id;
  final String companyName;
  final String positionTitle;
  final String? location;
  final WorkMode? workMode;
  final EmploymentType? employmentType;
  final int? salaryMin;
  final int? salaryMax;
  final String salaryCurrency;
  final SalaryPeriod? salaryPeriod;
  final String? jobUrl;
  final ApplicationStatus status;

  /// Date-only (UTC midnight). Set the first time the status leaves `saved`.
  final DateTime? appliedAt;

  /// Date-only (UTC midnight).
  final DateTime? deadlineAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ApplicationRow({
    required this.id,
    required this.companyName,
    required this.positionTitle,
    this.location,
    this.workMode,
    this.employmentType,
    this.salaryMin,
    this.salaryMax,
    required this.salaryCurrency,
    this.salaryPeriod,
    this.jobUrl,
    required this.status,
    this.appliedAt,
    this.deadlineAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['company_name'] = Variable<String>(companyName);
    map['position_title'] = Variable<String>(positionTitle);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || workMode != null) {
      map['work_mode'] = Variable<String>(
        $ApplicationsTable.$converterworkModen.toSql(workMode),
      );
    }
    if (!nullToAbsent || employmentType != null) {
      map['employment_type'] = Variable<String>(
        $ApplicationsTable.$converteremploymentTypen.toSql(employmentType),
      );
    }
    if (!nullToAbsent || salaryMin != null) {
      map['salary_min'] = Variable<int>(salaryMin);
    }
    if (!nullToAbsent || salaryMax != null) {
      map['salary_max'] = Variable<int>(salaryMax);
    }
    map['salary_currency'] = Variable<String>(salaryCurrency);
    if (!nullToAbsent || salaryPeriod != null) {
      map['salary_period'] = Variable<String>(
        $ApplicationsTable.$convertersalaryPeriodn.toSql(salaryPeriod),
      );
    }
    if (!nullToAbsent || jobUrl != null) {
      map['job_url'] = Variable<String>(jobUrl);
    }
    {
      map['status'] = Variable<String>(
        $ApplicationsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || appliedAt != null) {
      map['applied_at'] = Variable<DateTime>(appliedAt);
    }
    if (!nullToAbsent || deadlineAt != null) {
      map['deadline_at'] = Variable<DateTime>(deadlineAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ApplicationsCompanion toCompanion(bool nullToAbsent) {
    return ApplicationsCompanion(
      id: Value(id),
      companyName: Value(companyName),
      positionTitle: Value(positionTitle),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      workMode: workMode == null && nullToAbsent
          ? const Value.absent()
          : Value(workMode),
      employmentType: employmentType == null && nullToAbsent
          ? const Value.absent()
          : Value(employmentType),
      salaryMin: salaryMin == null && nullToAbsent
          ? const Value.absent()
          : Value(salaryMin),
      salaryMax: salaryMax == null && nullToAbsent
          ? const Value.absent()
          : Value(salaryMax),
      salaryCurrency: Value(salaryCurrency),
      salaryPeriod: salaryPeriod == null && nullToAbsent
          ? const Value.absent()
          : Value(salaryPeriod),
      jobUrl: jobUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(jobUrl),
      status: Value(status),
      appliedAt: appliedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(appliedAt),
      deadlineAt: deadlineAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deadlineAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ApplicationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApplicationRow(
      id: serializer.fromJson<int>(json['id']),
      companyName: serializer.fromJson<String>(json['companyName']),
      positionTitle: serializer.fromJson<String>(json['positionTitle']),
      location: serializer.fromJson<String?>(json['location']),
      workMode: $ApplicationsTable.$converterworkModen.fromJson(
        serializer.fromJson<String?>(json['workMode']),
      ),
      employmentType: $ApplicationsTable.$converteremploymentTypen.fromJson(
        serializer.fromJson<String?>(json['employmentType']),
      ),
      salaryMin: serializer.fromJson<int?>(json['salaryMin']),
      salaryMax: serializer.fromJson<int?>(json['salaryMax']),
      salaryCurrency: serializer.fromJson<String>(json['salaryCurrency']),
      salaryPeriod: $ApplicationsTable.$convertersalaryPeriodn.fromJson(
        serializer.fromJson<String?>(json['salaryPeriod']),
      ),
      jobUrl: serializer.fromJson<String?>(json['jobUrl']),
      status: $ApplicationsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      appliedAt: serializer.fromJson<DateTime?>(json['appliedAt']),
      deadlineAt: serializer.fromJson<DateTime?>(json['deadlineAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'companyName': serializer.toJson<String>(companyName),
      'positionTitle': serializer.toJson<String>(positionTitle),
      'location': serializer.toJson<String?>(location),
      'workMode': serializer.toJson<String?>(
        $ApplicationsTable.$converterworkModen.toJson(workMode),
      ),
      'employmentType': serializer.toJson<String?>(
        $ApplicationsTable.$converteremploymentTypen.toJson(employmentType),
      ),
      'salaryMin': serializer.toJson<int?>(salaryMin),
      'salaryMax': serializer.toJson<int?>(salaryMax),
      'salaryCurrency': serializer.toJson<String>(salaryCurrency),
      'salaryPeriod': serializer.toJson<String?>(
        $ApplicationsTable.$convertersalaryPeriodn.toJson(salaryPeriod),
      ),
      'jobUrl': serializer.toJson<String?>(jobUrl),
      'status': serializer.toJson<String>(
        $ApplicationsTable.$converterstatus.toJson(status),
      ),
      'appliedAt': serializer.toJson<DateTime?>(appliedAt),
      'deadlineAt': serializer.toJson<DateTime?>(deadlineAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ApplicationRow copyWith({
    int? id,
    String? companyName,
    String? positionTitle,
    Value<String?> location = const Value.absent(),
    Value<WorkMode?> workMode = const Value.absent(),
    Value<EmploymentType?> employmentType = const Value.absent(),
    Value<int?> salaryMin = const Value.absent(),
    Value<int?> salaryMax = const Value.absent(),
    String? salaryCurrency,
    Value<SalaryPeriod?> salaryPeriod = const Value.absent(),
    Value<String?> jobUrl = const Value.absent(),
    ApplicationStatus? status,
    Value<DateTime?> appliedAt = const Value.absent(),
    Value<DateTime?> deadlineAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ApplicationRow(
    id: id ?? this.id,
    companyName: companyName ?? this.companyName,
    positionTitle: positionTitle ?? this.positionTitle,
    location: location.present ? location.value : this.location,
    workMode: workMode.present ? workMode.value : this.workMode,
    employmentType: employmentType.present
        ? employmentType.value
        : this.employmentType,
    salaryMin: salaryMin.present ? salaryMin.value : this.salaryMin,
    salaryMax: salaryMax.present ? salaryMax.value : this.salaryMax,
    salaryCurrency: salaryCurrency ?? this.salaryCurrency,
    salaryPeriod: salaryPeriod.present ? salaryPeriod.value : this.salaryPeriod,
    jobUrl: jobUrl.present ? jobUrl.value : this.jobUrl,
    status: status ?? this.status,
    appliedAt: appliedAt.present ? appliedAt.value : this.appliedAt,
    deadlineAt: deadlineAt.present ? deadlineAt.value : this.deadlineAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ApplicationRow copyWithCompanion(ApplicationsCompanion data) {
    return ApplicationRow(
      id: data.id.present ? data.id.value : this.id,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      positionTitle: data.positionTitle.present
          ? data.positionTitle.value
          : this.positionTitle,
      location: data.location.present ? data.location.value : this.location,
      workMode: data.workMode.present ? data.workMode.value : this.workMode,
      employmentType: data.employmentType.present
          ? data.employmentType.value
          : this.employmentType,
      salaryMin: data.salaryMin.present ? data.salaryMin.value : this.salaryMin,
      salaryMax: data.salaryMax.present ? data.salaryMax.value : this.salaryMax,
      salaryCurrency: data.salaryCurrency.present
          ? data.salaryCurrency.value
          : this.salaryCurrency,
      salaryPeriod: data.salaryPeriod.present
          ? data.salaryPeriod.value
          : this.salaryPeriod,
      jobUrl: data.jobUrl.present ? data.jobUrl.value : this.jobUrl,
      status: data.status.present ? data.status.value : this.status,
      appliedAt: data.appliedAt.present ? data.appliedAt.value : this.appliedAt,
      deadlineAt: data.deadlineAt.present
          ? data.deadlineAt.value
          : this.deadlineAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApplicationRow(')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('positionTitle: $positionTitle, ')
          ..write('location: $location, ')
          ..write('workMode: $workMode, ')
          ..write('employmentType: $employmentType, ')
          ..write('salaryMin: $salaryMin, ')
          ..write('salaryMax: $salaryMax, ')
          ..write('salaryCurrency: $salaryCurrency, ')
          ..write('salaryPeriod: $salaryPeriod, ')
          ..write('jobUrl: $jobUrl, ')
          ..write('status: $status, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('deadlineAt: $deadlineAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    companyName,
    positionTitle,
    location,
    workMode,
    employmentType,
    salaryMin,
    salaryMax,
    salaryCurrency,
    salaryPeriod,
    jobUrl,
    status,
    appliedAt,
    deadlineAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApplicationRow &&
          other.id == this.id &&
          other.companyName == this.companyName &&
          other.positionTitle == this.positionTitle &&
          other.location == this.location &&
          other.workMode == this.workMode &&
          other.employmentType == this.employmentType &&
          other.salaryMin == this.salaryMin &&
          other.salaryMax == this.salaryMax &&
          other.salaryCurrency == this.salaryCurrency &&
          other.salaryPeriod == this.salaryPeriod &&
          other.jobUrl == this.jobUrl &&
          other.status == this.status &&
          other.appliedAt == this.appliedAt &&
          other.deadlineAt == this.deadlineAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ApplicationsCompanion extends UpdateCompanion<ApplicationRow> {
  final Value<int> id;
  final Value<String> companyName;
  final Value<String> positionTitle;
  final Value<String?> location;
  final Value<WorkMode?> workMode;
  final Value<EmploymentType?> employmentType;
  final Value<int?> salaryMin;
  final Value<int?> salaryMax;
  final Value<String> salaryCurrency;
  final Value<SalaryPeriod?> salaryPeriod;
  final Value<String?> jobUrl;
  final Value<ApplicationStatus> status;
  final Value<DateTime?> appliedAt;
  final Value<DateTime?> deadlineAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ApplicationsCompanion({
    this.id = const Value.absent(),
    this.companyName = const Value.absent(),
    this.positionTitle = const Value.absent(),
    this.location = const Value.absent(),
    this.workMode = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.salaryMin = const Value.absent(),
    this.salaryMax = const Value.absent(),
    this.salaryCurrency = const Value.absent(),
    this.salaryPeriod = const Value.absent(),
    this.jobUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.appliedAt = const Value.absent(),
    this.deadlineAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ApplicationsCompanion.insert({
    this.id = const Value.absent(),
    required String companyName,
    required String positionTitle,
    this.location = const Value.absent(),
    this.workMode = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.salaryMin = const Value.absent(),
    this.salaryMax = const Value.absent(),
    this.salaryCurrency = const Value.absent(),
    this.salaryPeriod = const Value.absent(),
    this.jobUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.appliedAt = const Value.absent(),
    this.deadlineAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : companyName = Value(companyName),
       positionTitle = Value(positionTitle),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ApplicationRow> custom({
    Expression<int>? id,
    Expression<String>? companyName,
    Expression<String>? positionTitle,
    Expression<String>? location,
    Expression<String>? workMode,
    Expression<String>? employmentType,
    Expression<int>? salaryMin,
    Expression<int>? salaryMax,
    Expression<String>? salaryCurrency,
    Expression<String>? salaryPeriod,
    Expression<String>? jobUrl,
    Expression<String>? status,
    Expression<DateTime>? appliedAt,
    Expression<DateTime>? deadlineAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (companyName != null) 'company_name': companyName,
      if (positionTitle != null) 'position_title': positionTitle,
      if (location != null) 'location': location,
      if (workMode != null) 'work_mode': workMode,
      if (employmentType != null) 'employment_type': employmentType,
      if (salaryMin != null) 'salary_min': salaryMin,
      if (salaryMax != null) 'salary_max': salaryMax,
      if (salaryCurrency != null) 'salary_currency': salaryCurrency,
      if (salaryPeriod != null) 'salary_period': salaryPeriod,
      if (jobUrl != null) 'job_url': jobUrl,
      if (status != null) 'status': status,
      if (appliedAt != null) 'applied_at': appliedAt,
      if (deadlineAt != null) 'deadline_at': deadlineAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ApplicationsCompanion copyWith({
    Value<int>? id,
    Value<String>? companyName,
    Value<String>? positionTitle,
    Value<String?>? location,
    Value<WorkMode?>? workMode,
    Value<EmploymentType?>? employmentType,
    Value<int?>? salaryMin,
    Value<int?>? salaryMax,
    Value<String>? salaryCurrency,
    Value<SalaryPeriod?>? salaryPeriod,
    Value<String?>? jobUrl,
    Value<ApplicationStatus>? status,
    Value<DateTime?>? appliedAt,
    Value<DateTime?>? deadlineAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ApplicationsCompanion(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      positionTitle: positionTitle ?? this.positionTitle,
      location: location ?? this.location,
      workMode: workMode ?? this.workMode,
      employmentType: employmentType ?? this.employmentType,
      salaryMin: salaryMin ?? this.salaryMin,
      salaryMax: salaryMax ?? this.salaryMax,
      salaryCurrency: salaryCurrency ?? this.salaryCurrency,
      salaryPeriod: salaryPeriod ?? this.salaryPeriod,
      jobUrl: jobUrl ?? this.jobUrl,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
      deadlineAt: deadlineAt ?? this.deadlineAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (positionTitle.present) {
      map['position_title'] = Variable<String>(positionTitle.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (workMode.present) {
      map['work_mode'] = Variable<String>(
        $ApplicationsTable.$converterworkModen.toSql(workMode.value),
      );
    }
    if (employmentType.present) {
      map['employment_type'] = Variable<String>(
        $ApplicationsTable.$converteremploymentTypen.toSql(
          employmentType.value,
        ),
      );
    }
    if (salaryMin.present) {
      map['salary_min'] = Variable<int>(salaryMin.value);
    }
    if (salaryMax.present) {
      map['salary_max'] = Variable<int>(salaryMax.value);
    }
    if (salaryCurrency.present) {
      map['salary_currency'] = Variable<String>(salaryCurrency.value);
    }
    if (salaryPeriod.present) {
      map['salary_period'] = Variable<String>(
        $ApplicationsTable.$convertersalaryPeriodn.toSql(salaryPeriod.value),
      );
    }
    if (jobUrl.present) {
      map['job_url'] = Variable<String>(jobUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ApplicationsTable.$converterstatus.toSql(status.value),
      );
    }
    if (appliedAt.present) {
      map['applied_at'] = Variable<DateTime>(appliedAt.value);
    }
    if (deadlineAt.present) {
      map['deadline_at'] = Variable<DateTime>(deadlineAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApplicationsCompanion(')
          ..write('id: $id, ')
          ..write('companyName: $companyName, ')
          ..write('positionTitle: $positionTitle, ')
          ..write('location: $location, ')
          ..write('workMode: $workMode, ')
          ..write('employmentType: $employmentType, ')
          ..write('salaryMin: $salaryMin, ')
          ..write('salaryMax: $salaryMax, ')
          ..write('salaryCurrency: $salaryCurrency, ')
          ..write('salaryPeriod: $salaryPeriod, ')
          ..write('jobUrl: $jobUrl, ')
          ..write('status: $status, ')
          ..write('appliedAt: $appliedAt, ')
          ..write('deadlineAt: $deadlineAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StatusHistoryTable extends StatusHistory
    with TableInfo<$StatusHistoryTable, StatusHistoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StatusHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _applicationIdMeta = const VerificationMeta(
    'applicationId',
  );
  @override
  late final GeneratedColumn<int> applicationId = GeneratedColumn<int>(
    'application_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES applications (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ApplicationStatus?, String>
  fromStatus =
      GeneratedColumn<String>(
        'from_status',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<ApplicationStatus?>(
        $StatusHistoryTable.$converterfromStatusn,
      );
  @override
  late final GeneratedColumnWithTypeConverter<ApplicationStatus, String>
  toStatus = GeneratedColumn<String>(
    'to_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<ApplicationStatus>($StatusHistoryTable.$convertertoStatus);
  static const VerificationMeta _changedAtMeta = const VerificationMeta(
    'changedAt',
  );
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
    'changed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    applicationId,
    fromStatus,
    toStatus,
    changedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'status_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<StatusHistoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('application_id')) {
      context.handle(
        _applicationIdMeta,
        applicationId.isAcceptableOrUnknown(
          data['application_id']!,
          _applicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_applicationIdMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(
        _changedAtMeta,
        changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StatusHistoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StatusHistoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      applicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}application_id'],
      )!,
      fromStatus: $StatusHistoryTable.$converterfromStatusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}from_status'],
        ),
      ),
      toStatus: $StatusHistoryTable.$convertertoStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}to_status'],
        )!,
      ),
      changedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}changed_at'],
      )!,
    );
  }

  @override
  $StatusHistoryTable createAlias(String alias) {
    return $StatusHistoryTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ApplicationStatus, String, String>
  $converterfromStatus = const EnumNameConverter<ApplicationStatus>(
    ApplicationStatus.values,
  );
  static JsonTypeConverter2<ApplicationStatus?, String?, String?>
  $converterfromStatusn = JsonTypeConverter2.asNullable($converterfromStatus);
  static JsonTypeConverter2<ApplicationStatus, String, String>
  $convertertoStatus = const EnumNameConverter<ApplicationStatus>(
    ApplicationStatus.values,
  );
}

class StatusHistoryRow extends DataClass
    implements Insertable<StatusHistoryRow> {
  final int id;
  final int applicationId;

  /// `NULL` for the initial status recorded on creation.
  final ApplicationStatus? fromStatus;
  final ApplicationStatus toStatus;
  final DateTime changedAt;
  const StatusHistoryRow({
    required this.id,
    required this.applicationId,
    this.fromStatus,
    required this.toStatus,
    required this.changedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['application_id'] = Variable<int>(applicationId);
    if (!nullToAbsent || fromStatus != null) {
      map['from_status'] = Variable<String>(
        $StatusHistoryTable.$converterfromStatusn.toSql(fromStatus),
      );
    }
    {
      map['to_status'] = Variable<String>(
        $StatusHistoryTable.$convertertoStatus.toSql(toStatus),
      );
    }
    map['changed_at'] = Variable<DateTime>(changedAt);
    return map;
  }

  StatusHistoryCompanion toCompanion(bool nullToAbsent) {
    return StatusHistoryCompanion(
      id: Value(id),
      applicationId: Value(applicationId),
      fromStatus: fromStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(fromStatus),
      toStatus: Value(toStatus),
      changedAt: Value(changedAt),
    );
  }

  factory StatusHistoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StatusHistoryRow(
      id: serializer.fromJson<int>(json['id']),
      applicationId: serializer.fromJson<int>(json['applicationId']),
      fromStatus: $StatusHistoryTable.$converterfromStatusn.fromJson(
        serializer.fromJson<String?>(json['fromStatus']),
      ),
      toStatus: $StatusHistoryTable.$convertertoStatus.fromJson(
        serializer.fromJson<String>(json['toStatus']),
      ),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'applicationId': serializer.toJson<int>(applicationId),
      'fromStatus': serializer.toJson<String?>(
        $StatusHistoryTable.$converterfromStatusn.toJson(fromStatus),
      ),
      'toStatus': serializer.toJson<String>(
        $StatusHistoryTable.$convertertoStatus.toJson(toStatus),
      ),
      'changedAt': serializer.toJson<DateTime>(changedAt),
    };
  }

  StatusHistoryRow copyWith({
    int? id,
    int? applicationId,
    Value<ApplicationStatus?> fromStatus = const Value.absent(),
    ApplicationStatus? toStatus,
    DateTime? changedAt,
  }) => StatusHistoryRow(
    id: id ?? this.id,
    applicationId: applicationId ?? this.applicationId,
    fromStatus: fromStatus.present ? fromStatus.value : this.fromStatus,
    toStatus: toStatus ?? this.toStatus,
    changedAt: changedAt ?? this.changedAt,
  );
  StatusHistoryRow copyWithCompanion(StatusHistoryCompanion data) {
    return StatusHistoryRow(
      id: data.id.present ? data.id.value : this.id,
      applicationId: data.applicationId.present
          ? data.applicationId.value
          : this.applicationId,
      fromStatus: data.fromStatus.present
          ? data.fromStatus.value
          : this.fromStatus,
      toStatus: data.toStatus.present ? data.toStatus.value : this.toStatus,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StatusHistoryRow(')
          ..write('id: $id, ')
          ..write('applicationId: $applicationId, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, applicationId, fromStatus, toStatus, changedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatusHistoryRow &&
          other.id == this.id &&
          other.applicationId == this.applicationId &&
          other.fromStatus == this.fromStatus &&
          other.toStatus == this.toStatus &&
          other.changedAt == this.changedAt);
}

class StatusHistoryCompanion extends UpdateCompanion<StatusHistoryRow> {
  final Value<int> id;
  final Value<int> applicationId;
  final Value<ApplicationStatus?> fromStatus;
  final Value<ApplicationStatus> toStatus;
  final Value<DateTime> changedAt;
  const StatusHistoryCompanion({
    this.id = const Value.absent(),
    this.applicationId = const Value.absent(),
    this.fromStatus = const Value.absent(),
    this.toStatus = const Value.absent(),
    this.changedAt = const Value.absent(),
  });
  StatusHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int applicationId,
    this.fromStatus = const Value.absent(),
    required ApplicationStatus toStatus,
    required DateTime changedAt,
  }) : applicationId = Value(applicationId),
       toStatus = Value(toStatus),
       changedAt = Value(changedAt);
  static Insertable<StatusHistoryRow> custom({
    Expression<int>? id,
    Expression<int>? applicationId,
    Expression<String>? fromStatus,
    Expression<String>? toStatus,
    Expression<DateTime>? changedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (applicationId != null) 'application_id': applicationId,
      if (fromStatus != null) 'from_status': fromStatus,
      if (toStatus != null) 'to_status': toStatus,
      if (changedAt != null) 'changed_at': changedAt,
    });
  }

  StatusHistoryCompanion copyWith({
    Value<int>? id,
    Value<int>? applicationId,
    Value<ApplicationStatus?>? fromStatus,
    Value<ApplicationStatus>? toStatus,
    Value<DateTime>? changedAt,
  }) {
    return StatusHistoryCompanion(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      fromStatus: fromStatus ?? this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
      changedAt: changedAt ?? this.changedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (applicationId.present) {
      map['application_id'] = Variable<int>(applicationId.value);
    }
    if (fromStatus.present) {
      map['from_status'] = Variable<String>(
        $StatusHistoryTable.$converterfromStatusn.toSql(fromStatus.value),
      );
    }
    if (toStatus.present) {
      map['to_status'] = Variable<String>(
        $StatusHistoryTable.$convertertoStatus.toSql(toStatus.value),
      );
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StatusHistoryCompanion(')
          ..write('id: $id, ')
          ..write('applicationId: $applicationId, ')
          ..write('fromStatus: $fromStatus, ')
          ..write('toStatus: $toStatus, ')
          ..write('changedAt: $changedAt')
          ..write(')'))
        .toString();
  }
}

class $InterviewsTable extends Interviews
    with TableInfo<$InterviewsTable, InterviewRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InterviewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _applicationIdMeta = const VerificationMeta(
    'applicationId',
  );
  @override
  late final GeneratedColumn<int> applicationId = GeneratedColumn<int>(
    'application_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES applications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InterviewFormat, String> format =
      GeneratedColumn<String>(
        'format',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InterviewFormat>($InterviewsTable.$converterformat);
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interviewerMeta = const VerificationMeta(
    'interviewer',
  );
  @override
  late final GeneratedColumn<String> interviewer = GeneratedColumn<String>(
    'interviewer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InterviewOutcome, String>
  outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: Constant(InterviewOutcome.pending.name),
  ).withConverter<InterviewOutcome>($InterviewsTable.$converteroutcome);
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    applicationId,
    title,
    format,
    scheduledAt,
    durationMinutes,
    location,
    interviewer,
    outcome,
    summary,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interviews';
  @override
  VerificationContext validateIntegrity(
    Insertable<InterviewRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('application_id')) {
      context.handle(
        _applicationIdMeta,
        applicationId.isAcceptableOrUnknown(
          data['application_id']!,
          _applicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_applicationIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('interviewer')) {
      context.handle(
        _interviewerMeta,
        interviewer.isAcceptableOrUnknown(
          data['interviewer']!,
          _interviewerMeta,
        ),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InterviewRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InterviewRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      applicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}application_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      format: $InterviewsTable.$converterformat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}format'],
        )!,
      ),
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      interviewer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}interviewer'],
      ),
      outcome: $InterviewsTable.$converteroutcome.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}outcome'],
        )!,
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InterviewsTable createAlias(String alias) {
    return $InterviewsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InterviewFormat, String, String> $converterformat =
      const EnumNameConverter<InterviewFormat>(InterviewFormat.values);
  static JsonTypeConverter2<InterviewOutcome, String, String>
  $converteroutcome = const EnumNameConverter<InterviewOutcome>(
    InterviewOutcome.values,
  );
}

class InterviewRow extends DataClass implements Insertable<InterviewRow> {
  final int id;
  final int applicationId;
  final String title;
  final InterviewFormat format;
  final DateTime scheduledAt;
  final int? durationMinutes;
  final String? location;
  final String? interviewer;
  final InterviewOutcome outcome;
  final String? summary;
  final DateTime createdAt;
  final DateTime updatedAt;
  const InterviewRow({
    required this.id,
    required this.applicationId,
    required this.title,
    required this.format,
    required this.scheduledAt,
    this.durationMinutes,
    this.location,
    this.interviewer,
    required this.outcome,
    this.summary,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['application_id'] = Variable<int>(applicationId);
    map['title'] = Variable<String>(title);
    {
      map['format'] = Variable<String>(
        $InterviewsTable.$converterformat.toSql(format),
      );
    }
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<int>(durationMinutes);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || interviewer != null) {
      map['interviewer'] = Variable<String>(interviewer);
    }
    {
      map['outcome'] = Variable<String>(
        $InterviewsTable.$converteroutcome.toSql(outcome),
      );
    }
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InterviewsCompanion toCompanion(bool nullToAbsent) {
    return InterviewsCompanion(
      id: Value(id),
      applicationId: Value(applicationId),
      title: Value(title),
      format: Value(format),
      scheduledAt: Value(scheduledAt),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      interviewer: interviewer == null && nullToAbsent
          ? const Value.absent()
          : Value(interviewer),
      outcome: Value(outcome),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory InterviewRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InterviewRow(
      id: serializer.fromJson<int>(json['id']),
      applicationId: serializer.fromJson<int>(json['applicationId']),
      title: serializer.fromJson<String>(json['title']),
      format: $InterviewsTable.$converterformat.fromJson(
        serializer.fromJson<String>(json['format']),
      ),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      durationMinutes: serializer.fromJson<int?>(json['durationMinutes']),
      location: serializer.fromJson<String?>(json['location']),
      interviewer: serializer.fromJson<String?>(json['interviewer']),
      outcome: $InterviewsTable.$converteroutcome.fromJson(
        serializer.fromJson<String>(json['outcome']),
      ),
      summary: serializer.fromJson<String?>(json['summary']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'applicationId': serializer.toJson<int>(applicationId),
      'title': serializer.toJson<String>(title),
      'format': serializer.toJson<String>(
        $InterviewsTable.$converterformat.toJson(format),
      ),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'durationMinutes': serializer.toJson<int?>(durationMinutes),
      'location': serializer.toJson<String?>(location),
      'interviewer': serializer.toJson<String?>(interviewer),
      'outcome': serializer.toJson<String>(
        $InterviewsTable.$converteroutcome.toJson(outcome),
      ),
      'summary': serializer.toJson<String?>(summary),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  InterviewRow copyWith({
    int? id,
    int? applicationId,
    String? title,
    InterviewFormat? format,
    DateTime? scheduledAt,
    Value<int?> durationMinutes = const Value.absent(),
    Value<String?> location = const Value.absent(),
    Value<String?> interviewer = const Value.absent(),
    InterviewOutcome? outcome,
    Value<String?> summary = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => InterviewRow(
    id: id ?? this.id,
    applicationId: applicationId ?? this.applicationId,
    title: title ?? this.title,
    format: format ?? this.format,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    durationMinutes: durationMinutes.present
        ? durationMinutes.value
        : this.durationMinutes,
    location: location.present ? location.value : this.location,
    interviewer: interviewer.present ? interviewer.value : this.interviewer,
    outcome: outcome ?? this.outcome,
    summary: summary.present ? summary.value : this.summary,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  InterviewRow copyWithCompanion(InterviewsCompanion data) {
    return InterviewRow(
      id: data.id.present ? data.id.value : this.id,
      applicationId: data.applicationId.present
          ? data.applicationId.value
          : this.applicationId,
      title: data.title.present ? data.title.value : this.title,
      format: data.format.present ? data.format.value : this.format,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      location: data.location.present ? data.location.value : this.location,
      interviewer: data.interviewer.present
          ? data.interviewer.value
          : this.interviewer,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      summary: data.summary.present ? data.summary.value : this.summary,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InterviewRow(')
          ..write('id: $id, ')
          ..write('applicationId: $applicationId, ')
          ..write('title: $title, ')
          ..write('format: $format, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('location: $location, ')
          ..write('interviewer: $interviewer, ')
          ..write('outcome: $outcome, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    applicationId,
    title,
    format,
    scheduledAt,
    durationMinutes,
    location,
    interviewer,
    outcome,
    summary,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InterviewRow &&
          other.id == this.id &&
          other.applicationId == this.applicationId &&
          other.title == this.title &&
          other.format == this.format &&
          other.scheduledAt == this.scheduledAt &&
          other.durationMinutes == this.durationMinutes &&
          other.location == this.location &&
          other.interviewer == this.interviewer &&
          other.outcome == this.outcome &&
          other.summary == this.summary &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InterviewsCompanion extends UpdateCompanion<InterviewRow> {
  final Value<int> id;
  final Value<int> applicationId;
  final Value<String> title;
  final Value<InterviewFormat> format;
  final Value<DateTime> scheduledAt;
  final Value<int?> durationMinutes;
  final Value<String?> location;
  final Value<String?> interviewer;
  final Value<InterviewOutcome> outcome;
  final Value<String?> summary;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const InterviewsCompanion({
    this.id = const Value.absent(),
    this.applicationId = const Value.absent(),
    this.title = const Value.absent(),
    this.format = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.location = const Value.absent(),
    this.interviewer = const Value.absent(),
    this.outcome = const Value.absent(),
    this.summary = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  InterviewsCompanion.insert({
    this.id = const Value.absent(),
    required int applicationId,
    required String title,
    required InterviewFormat format,
    required DateTime scheduledAt,
    this.durationMinutes = const Value.absent(),
    this.location = const Value.absent(),
    this.interviewer = const Value.absent(),
    this.outcome = const Value.absent(),
    this.summary = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : applicationId = Value(applicationId),
       title = Value(title),
       format = Value(format),
       scheduledAt = Value(scheduledAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<InterviewRow> custom({
    Expression<int>? id,
    Expression<int>? applicationId,
    Expression<String>? title,
    Expression<String>? format,
    Expression<DateTime>? scheduledAt,
    Expression<int>? durationMinutes,
    Expression<String>? location,
    Expression<String>? interviewer,
    Expression<String>? outcome,
    Expression<String>? summary,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (applicationId != null) 'application_id': applicationId,
      if (title != null) 'title': title,
      if (format != null) 'format': format,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (location != null) 'location': location,
      if (interviewer != null) 'interviewer': interviewer,
      if (outcome != null) 'outcome': outcome,
      if (summary != null) 'summary': summary,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  InterviewsCompanion copyWith({
    Value<int>? id,
    Value<int>? applicationId,
    Value<String>? title,
    Value<InterviewFormat>? format,
    Value<DateTime>? scheduledAt,
    Value<int?>? durationMinutes,
    Value<String?>? location,
    Value<String?>? interviewer,
    Value<InterviewOutcome>? outcome,
    Value<String?>? summary,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return InterviewsCompanion(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      title: title ?? this.title,
      format: format ?? this.format,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      location: location ?? this.location,
      interviewer: interviewer ?? this.interviewer,
      outcome: outcome ?? this.outcome,
      summary: summary ?? this.summary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (applicationId.present) {
      map['application_id'] = Variable<int>(applicationId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(
        $InterviewsTable.$converterformat.toSql(format.value),
      );
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (interviewer.present) {
      map['interviewer'] = Variable<String>(interviewer.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(
        $InterviewsTable.$converteroutcome.toSql(outcome.value),
      );
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InterviewsCompanion(')
          ..write('id: $id, ')
          ..write('applicationId: $applicationId, ')
          ..write('title: $title, ')
          ..write('format: $format, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('location: $location, ')
          ..write('interviewer: $interviewer, ')
          ..write('outcome: $outcome, ')
          ..write('summary: $summary, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ChecklistItemsTable extends ChecklistItems
    with TableInfo<$ChecklistItemsTable, ChecklistItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _applicationIdMeta = const VerificationMeta(
    'applicationId',
  );
  @override
  late final GeneratedColumn<int> applicationId = GeneratedColumn<int>(
    'application_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES applications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _interviewIdMeta = const VerificationMeta(
    'interviewId',
  );
  @override
  late final GeneratedColumn<int> interviewId = GeneratedColumn<int>(
    'interview_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES interviews (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
    'is_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    applicationId,
    interviewId,
    title,
    isDone,
    position,
    completedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChecklistItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('application_id')) {
      context.handle(
        _applicationIdMeta,
        applicationId.isAcceptableOrUnknown(
          data['application_id']!,
          _applicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_applicationIdMeta);
    }
    if (data.containsKey('interview_id')) {
      context.handle(
        _interviewIdMeta,
        interviewId.isAcceptableOrUnknown(
          data['interview_id']!,
          _interviewIdMeta,
        ),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(
        _isDoneMeta,
        isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta),
      );
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      applicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}application_id'],
      )!,
      interviewId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interview_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      isDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_done'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ChecklistItemsTable createAlias(String alias) {
    return $ChecklistItemsTable(attachedDatabase, alias);
  }
}

class ChecklistItemRow extends DataClass
    implements Insertable<ChecklistItemRow> {
  final int id;
  final int applicationId;

  /// Optional: the interview this task prepares for.
  final int? interviewId;
  final String title;
  final bool isDone;
  final int position;
  final DateTime? completedAt;
  final DateTime createdAt;
  const ChecklistItemRow({
    required this.id,
    required this.applicationId,
    this.interviewId,
    required this.title,
    required this.isDone,
    required this.position,
    this.completedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['application_id'] = Variable<int>(applicationId);
    if (!nullToAbsent || interviewId != null) {
      map['interview_id'] = Variable<int>(interviewId);
    }
    map['title'] = Variable<String>(title);
    map['is_done'] = Variable<bool>(isDone);
    map['position'] = Variable<int>(position);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistItemsCompanion(
      id: Value(id),
      applicationId: Value(applicationId),
      interviewId: interviewId == null && nullToAbsent
          ? const Value.absent()
          : Value(interviewId),
      title: Value(title),
      isDone: Value(isDone),
      position: Value(position),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      createdAt: Value(createdAt),
    );
  }

  factory ChecklistItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistItemRow(
      id: serializer.fromJson<int>(json['id']),
      applicationId: serializer.fromJson<int>(json['applicationId']),
      interviewId: serializer.fromJson<int?>(json['interviewId']),
      title: serializer.fromJson<String>(json['title']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      position: serializer.fromJson<int>(json['position']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'applicationId': serializer.toJson<int>(applicationId),
      'interviewId': serializer.toJson<int?>(interviewId),
      'title': serializer.toJson<String>(title),
      'isDone': serializer.toJson<bool>(isDone),
      'position': serializer.toJson<int>(position),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChecklistItemRow copyWith({
    int? id,
    int? applicationId,
    Value<int?> interviewId = const Value.absent(),
    String? title,
    bool? isDone,
    int? position,
    Value<DateTime?> completedAt = const Value.absent(),
    DateTime? createdAt,
  }) => ChecklistItemRow(
    id: id ?? this.id,
    applicationId: applicationId ?? this.applicationId,
    interviewId: interviewId.present ? interviewId.value : this.interviewId,
    title: title ?? this.title,
    isDone: isDone ?? this.isDone,
    position: position ?? this.position,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  ChecklistItemRow copyWithCompanion(ChecklistItemsCompanion data) {
    return ChecklistItemRow(
      id: data.id.present ? data.id.value : this.id,
      applicationId: data.applicationId.present
          ? data.applicationId.value
          : this.applicationId,
      interviewId: data.interviewId.present
          ? data.interviewId.value
          : this.interviewId,
      title: data.title.present ? data.title.value : this.title,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      position: data.position.present ? data.position.value : this.position,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemRow(')
          ..write('id: $id, ')
          ..write('applicationId: $applicationId, ')
          ..write('interviewId: $interviewId, ')
          ..write('title: $title, ')
          ..write('isDone: $isDone, ')
          ..write('position: $position, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    applicationId,
    interviewId,
    title,
    isDone,
    position,
    completedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistItemRow &&
          other.id == this.id &&
          other.applicationId == this.applicationId &&
          other.interviewId == this.interviewId &&
          other.title == this.title &&
          other.isDone == this.isDone &&
          other.position == this.position &&
          other.completedAt == this.completedAt &&
          other.createdAt == this.createdAt);
}

class ChecklistItemsCompanion extends UpdateCompanion<ChecklistItemRow> {
  final Value<int> id;
  final Value<int> applicationId;
  final Value<int?> interviewId;
  final Value<String> title;
  final Value<bool> isDone;
  final Value<int> position;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  const ChecklistItemsCompanion({
    this.id = const Value.absent(),
    this.applicationId = const Value.absent(),
    this.interviewId = const Value.absent(),
    this.title = const Value.absent(),
    this.isDone = const Value.absent(),
    this.position = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ChecklistItemsCompanion.insert({
    this.id = const Value.absent(),
    required int applicationId,
    this.interviewId = const Value.absent(),
    required String title,
    this.isDone = const Value.absent(),
    required int position,
    this.completedAt = const Value.absent(),
    required DateTime createdAt,
  }) : applicationId = Value(applicationId),
       title = Value(title),
       position = Value(position),
       createdAt = Value(createdAt);
  static Insertable<ChecklistItemRow> custom({
    Expression<int>? id,
    Expression<int>? applicationId,
    Expression<int>? interviewId,
    Expression<String>? title,
    Expression<bool>? isDone,
    Expression<int>? position,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (applicationId != null) 'application_id': applicationId,
      if (interviewId != null) 'interview_id': interviewId,
      if (title != null) 'title': title,
      if (isDone != null) 'is_done': isDone,
      if (position != null) 'position': position,
      if (completedAt != null) 'completed_at': completedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ChecklistItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? applicationId,
    Value<int?>? interviewId,
    Value<String>? title,
    Value<bool>? isDone,
    Value<int>? position,
    Value<DateTime?>? completedAt,
    Value<DateTime>? createdAt,
  }) {
    return ChecklistItemsCompanion(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      interviewId: interviewId ?? this.interviewId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      position: position ?? this.position,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (applicationId.present) {
      map['application_id'] = Variable<int>(applicationId.value);
    }
    if (interviewId.present) {
      map['interview_id'] = Variable<int>(interviewId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemsCompanion(')
          ..write('id: $id, ')
          ..write('applicationId: $applicationId, ')
          ..write('interviewId: $interviewId, ')
          ..write('title: $title, ')
          ..write('isDone: $isDone, ')
          ..write('position: $position, ')
          ..write('completedAt: $completedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, NoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _applicationIdMeta = const VerificationMeta(
    'applicationId',
  );
  @override
  late final GeneratedColumn<int> applicationId = GeneratedColumn<int>(
    'application_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES applications (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    applicationId,
    content,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('application_id')) {
      context.handle(
        _applicationIdMeta,
        applicationId.isAcceptableOrUnknown(
          data['application_id']!,
          _applicationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_applicationIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      applicationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}application_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class NoteRow extends DataClass implements Insertable<NoteRow> {
  final int id;
  final int applicationId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NoteRow({
    required this.id,
    required this.applicationId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['application_id'] = Variable<int>(applicationId);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      applicationId: Value(applicationId),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteRow(
      id: serializer.fromJson<int>(json['id']),
      applicationId: serializer.fromJson<int>(json['applicationId']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'applicationId': serializer.toJson<int>(applicationId),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NoteRow copyWith({
    int? id,
    int? applicationId,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NoteRow(
    id: id ?? this.id,
    applicationId: applicationId ?? this.applicationId,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NoteRow copyWithCompanion(NotesCompanion data) {
    return NoteRow(
      id: data.id.present ? data.id.value : this.id,
      applicationId: data.applicationId.present
          ? data.applicationId.value
          : this.applicationId,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteRow(')
          ..write('id: $id, ')
          ..write('applicationId: $applicationId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, applicationId, content, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteRow &&
          other.id == this.id &&
          other.applicationId == this.applicationId &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<NoteRow> {
  final Value<int> id;
  final Value<int> applicationId;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.applicationId = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotesCompanion.insert({
    this.id = const Value.absent(),
    required int applicationId,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : applicationId = Value(applicationId),
       content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<NoteRow> custom({
    Expression<int>? id,
    Expression<int>? applicationId,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (applicationId != null) 'application_id': applicationId,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotesCompanion copyWith({
    Value<int>? id,
    Value<int>? applicationId,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      applicationId: applicationId ?? this.applicationId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (applicationId.present) {
      map['application_id'] = Variable<int>(applicationId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('applicationId: $applicationId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ApplicationsTable applications = $ApplicationsTable(this);
  late final $StatusHistoryTable statusHistory = $StatusHistoryTable(this);
  late final $InterviewsTable interviews = $InterviewsTable(this);
  late final $ChecklistItemsTable checklistItems = $ChecklistItemsTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final Index applicationsStatus = Index(
    'applications_status',
    'CREATE INDEX applications_status ON applications (status)',
  );
  late final Index applicationsAppliedAt = Index(
    'applications_applied_at',
    'CREATE INDEX applications_applied_at ON applications (applied_at)',
  );
  late final Index applicationsDeadlineAt = Index(
    'applications_deadline_at',
    'CREATE INDEX applications_deadline_at ON applications (deadline_at)',
  );
  late final Index statusHistoryApplication = Index(
    'status_history_application',
    'CREATE INDEX status_history_application ON status_history (application_id, changed_at)',
  );
  late final Index interviewsApplication = Index(
    'interviews_application',
    'CREATE INDEX interviews_application ON interviews (application_id)',
  );
  late final Index interviewsScheduledAt = Index(
    'interviews_scheduled_at',
    'CREATE INDEX interviews_scheduled_at ON interviews (scheduled_at)',
  );
  late final Index checklistItemsApplication = Index(
    'checklist_items_application',
    'CREATE INDEX checklist_items_application ON checklist_items (application_id, position)',
  );
  late final Index checklistItemsInterview = Index(
    'checklist_items_interview',
    'CREATE INDEX checklist_items_interview ON checklist_items (interview_id)',
  );
  late final Index notesApplication = Index(
    'notes_application',
    'CREATE INDEX notes_application ON notes (application_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    applications,
    statusHistory,
    interviews,
    checklistItems,
    notes,
    applicationsStatus,
    applicationsAppliedAt,
    applicationsDeadlineAt,
    statusHistoryApplication,
    interviewsApplication,
    interviewsScheduledAt,
    checklistItemsApplication,
    checklistItemsInterview,
    notesApplication,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'applications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('status_history', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'applications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('interviews', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'applications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('checklist_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'interviews',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('checklist_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'applications',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('notes', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ApplicationsTableCreateCompanionBuilder =
    ApplicationsCompanion Function({
      Value<int> id,
      required String companyName,
      required String positionTitle,
      Value<String?> location,
      Value<WorkMode?> workMode,
      Value<EmploymentType?> employmentType,
      Value<int?> salaryMin,
      Value<int?> salaryMax,
      Value<String> salaryCurrency,
      Value<SalaryPeriod?> salaryPeriod,
      Value<String?> jobUrl,
      Value<ApplicationStatus> status,
      Value<DateTime?> appliedAt,
      Value<DateTime?> deadlineAt,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ApplicationsTableUpdateCompanionBuilder =
    ApplicationsCompanion Function({
      Value<int> id,
      Value<String> companyName,
      Value<String> positionTitle,
      Value<String?> location,
      Value<WorkMode?> workMode,
      Value<EmploymentType?> employmentType,
      Value<int?> salaryMin,
      Value<int?> salaryMax,
      Value<String> salaryCurrency,
      Value<SalaryPeriod?> salaryPeriod,
      Value<String?> jobUrl,
      Value<ApplicationStatus> status,
      Value<DateTime?> appliedAt,
      Value<DateTime?> deadlineAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ApplicationsTableReferences
    extends BaseReferences<_$AppDatabase, $ApplicationsTable, ApplicationRow> {
  $$ApplicationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$StatusHistoryTable, List<StatusHistoryRow>>
  _statusHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.statusHistory,
    aliasName: 'applications__id__status_history__application_id',
  );

  $$StatusHistoryTableProcessedTableManager get statusHistoryRefs {
    final manager = $$StatusHistoryTableTableManager(
      $_db,
      $_db.statusHistory,
    ).filter((f) => f.applicationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_statusHistoryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InterviewsTable, List<InterviewRow>>
  _interviewsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.interviews,
    aliasName: 'applications__id__interviews__application_id',
  );

  $$InterviewsTableProcessedTableManager get interviewsRefs {
    final manager = $$InterviewsTableTableManager(
      $_db,
      $_db.interviews,
    ).filter((f) => f.applicationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_interviewsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChecklistItemsTable, List<ChecklistItemRow>>
  _checklistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.checklistItems,
    aliasName: 'applications__id__checklist_items__application_id',
  );

  $$ChecklistItemsTableProcessedTableManager get checklistItemsRefs {
    final manager = $$ChecklistItemsTableTableManager(
      $_db,
      $_db.checklistItems,
    ).filter((f) => f.applicationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_checklistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<NoteRow>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: 'applications__id__notes__application_id',
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.applicationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ApplicationsTableFilterComposer
    extends Composer<_$AppDatabase, $ApplicationsTable> {
  $$ApplicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get positionTitle => $composableBuilder(
    column: $table.positionTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WorkMode?, WorkMode, String> get workMode =>
      $composableBuilder(
        column: $table.workMode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<EmploymentType?, EmploymentType, String>
  get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get salaryMin => $composableBuilder(
    column: $table.salaryMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salaryMax => $composableBuilder(
    column: $table.salaryMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get salaryCurrency => $composableBuilder(
    column: $table.salaryCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SalaryPeriod?, SalaryPeriod, String>
  get salaryPeriod => $composableBuilder(
    column: $table.salaryPeriod,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get jobUrl => $composableBuilder(
    column: $table.jobUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ApplicationStatus, ApplicationStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadlineAt => $composableBuilder(
    column: $table.deadlineAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> statusHistoryRefs(
    Expression<bool> Function($$StatusHistoryTableFilterComposer f) f,
  ) {
    final $$StatusHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.statusHistory,
      getReferencedColumn: (t) => t.applicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StatusHistoryTableFilterComposer(
            $db: $db,
            $table: $db.statusHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> interviewsRefs(
    Expression<bool> Function($$InterviewsTableFilterComposer f) f,
  ) {
    final $$InterviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interviews,
      getReferencedColumn: (t) => t.applicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterviewsTableFilterComposer(
            $db: $db,
            $table: $db.interviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> checklistItemsRefs(
    Expression<bool> Function($$ChecklistItemsTableFilterComposer f) f,
  ) {
    final $$ChecklistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.applicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableFilterComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.applicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ApplicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ApplicationsTable> {
  $$ApplicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get positionTitle => $composableBuilder(
    column: $table.positionTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workMode => $composableBuilder(
    column: $table.workMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salaryMin => $composableBuilder(
    column: $table.salaryMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salaryMax => $composableBuilder(
    column: $table.salaryMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salaryCurrency => $composableBuilder(
    column: $table.salaryCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salaryPeriod => $composableBuilder(
    column: $table.salaryPeriod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobUrl => $composableBuilder(
    column: $table.jobUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get appliedAt => $composableBuilder(
    column: $table.appliedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadlineAt => $composableBuilder(
    column: $table.deadlineAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ApplicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApplicationsTable> {
  $$ApplicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get positionTitle => $composableBuilder(
    column: $table.positionTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WorkMode?, String> get workMode =>
      $composableBuilder(column: $table.workMode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EmploymentType?, String>
  get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get salaryMin =>
      $composableBuilder(column: $table.salaryMin, builder: (column) => column);

  GeneratedColumn<int> get salaryMax =>
      $composableBuilder(column: $table.salaryMax, builder: (column) => column);

  GeneratedColumn<String> get salaryCurrency => $composableBuilder(
    column: $table.salaryCurrency,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SalaryPeriod?, String> get salaryPeriod =>
      $composableBuilder(
        column: $table.salaryPeriod,
        builder: (column) => column,
      );

  GeneratedColumn<String> get jobUrl =>
      $composableBuilder(column: $table.jobUrl, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ApplicationStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get appliedAt =>
      $composableBuilder(column: $table.appliedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deadlineAt => $composableBuilder(
    column: $table.deadlineAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> statusHistoryRefs<T extends Object>(
    Expression<T> Function($$StatusHistoryTableAnnotationComposer a) f,
  ) {
    final $$StatusHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.statusHistory,
      getReferencedColumn: (t) => t.applicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StatusHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.statusHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> interviewsRefs<T extends Object>(
    Expression<T> Function($$InterviewsTableAnnotationComposer a) f,
  ) {
    final $$InterviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interviews,
      getReferencedColumn: (t) => t.applicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.interviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> checklistItemsRefs<T extends Object>(
    Expression<T> Function($$ChecklistItemsTableAnnotationComposer a) f,
  ) {
    final $$ChecklistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.applicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.applicationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ApplicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ApplicationsTable,
          ApplicationRow,
          $$ApplicationsTableFilterComposer,
          $$ApplicationsTableOrderingComposer,
          $$ApplicationsTableAnnotationComposer,
          $$ApplicationsTableCreateCompanionBuilder,
          $$ApplicationsTableUpdateCompanionBuilder,
          (ApplicationRow, $$ApplicationsTableReferences),
          ApplicationRow,
          PrefetchHooks Function({
            bool statusHistoryRefs,
            bool interviewsRefs,
            bool checklistItemsRefs,
            bool notesRefs,
          })
        > {
  $$ApplicationsTableTableManager(_$AppDatabase db, $ApplicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApplicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApplicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApplicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> companyName = const Value.absent(),
                Value<String> positionTitle = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<WorkMode?> workMode = const Value.absent(),
                Value<EmploymentType?> employmentType = const Value.absent(),
                Value<int?> salaryMin = const Value.absent(),
                Value<int?> salaryMax = const Value.absent(),
                Value<String> salaryCurrency = const Value.absent(),
                Value<SalaryPeriod?> salaryPeriod = const Value.absent(),
                Value<String?> jobUrl = const Value.absent(),
                Value<ApplicationStatus> status = const Value.absent(),
                Value<DateTime?> appliedAt = const Value.absent(),
                Value<DateTime?> deadlineAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ApplicationsCompanion(
                id: id,
                companyName: companyName,
                positionTitle: positionTitle,
                location: location,
                workMode: workMode,
                employmentType: employmentType,
                salaryMin: salaryMin,
                salaryMax: salaryMax,
                salaryCurrency: salaryCurrency,
                salaryPeriod: salaryPeriod,
                jobUrl: jobUrl,
                status: status,
                appliedAt: appliedAt,
                deadlineAt: deadlineAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String companyName,
                required String positionTitle,
                Value<String?> location = const Value.absent(),
                Value<WorkMode?> workMode = const Value.absent(),
                Value<EmploymentType?> employmentType = const Value.absent(),
                Value<int?> salaryMin = const Value.absent(),
                Value<int?> salaryMax = const Value.absent(),
                Value<String> salaryCurrency = const Value.absent(),
                Value<SalaryPeriod?> salaryPeriod = const Value.absent(),
                Value<String?> jobUrl = const Value.absent(),
                Value<ApplicationStatus> status = const Value.absent(),
                Value<DateTime?> appliedAt = const Value.absent(),
                Value<DateTime?> deadlineAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ApplicationsCompanion.insert(
                id: id,
                companyName: companyName,
                positionTitle: positionTitle,
                location: location,
                workMode: workMode,
                employmentType: employmentType,
                salaryMin: salaryMin,
                salaryMax: salaryMax,
                salaryCurrency: salaryCurrency,
                salaryPeriod: salaryPeriod,
                jobUrl: jobUrl,
                status: status,
                appliedAt: appliedAt,
                deadlineAt: deadlineAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ApplicationsTable, ApplicationRow>(table),
                  $$ApplicationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                statusHistoryRefs = false,
                interviewsRefs = false,
                checklistItemsRefs = false,
                notesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (statusHistoryRefs) db.statusHistory,
                    if (interviewsRefs) db.interviews,
                    if (checklistItemsRefs) db.checklistItems,
                    if (notesRefs) db.notes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (statusHistoryRefs)
                        await $_getPrefetchedData<
                          ApplicationRow,
                          $ApplicationsTable,
                          StatusHistoryRow
                        >(
                          currentTable: table,
                          referencedTable: $$ApplicationsTableReferences
                              ._statusHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ApplicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).statusHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.applicationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (interviewsRefs)
                        await $_getPrefetchedData<
                          ApplicationRow,
                          $ApplicationsTable,
                          InterviewRow
                        >(
                          currentTable: table,
                          referencedTable: $$ApplicationsTableReferences
                              ._interviewsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ApplicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).interviewsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.applicationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (checklistItemsRefs)
                        await $_getPrefetchedData<
                          ApplicationRow,
                          $ApplicationsTable,
                          ChecklistItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$ApplicationsTableReferences
                              ._checklistItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ApplicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).checklistItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.applicationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notesRefs)
                        await $_getPrefetchedData<
                          ApplicationRow,
                          $ApplicationsTable,
                          NoteRow
                        >(
                          currentTable: table,
                          referencedTable: $$ApplicationsTableReferences
                              ._notesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ApplicationsTableReferences(
                                db,
                                table,
                                p0,
                              ).notesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.applicationId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ApplicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ApplicationsTable,
      ApplicationRow,
      $$ApplicationsTableFilterComposer,
      $$ApplicationsTableOrderingComposer,
      $$ApplicationsTableAnnotationComposer,
      $$ApplicationsTableCreateCompanionBuilder,
      $$ApplicationsTableUpdateCompanionBuilder,
      (ApplicationRow, $$ApplicationsTableReferences),
      ApplicationRow,
      PrefetchHooks Function({
        bool statusHistoryRefs,
        bool interviewsRefs,
        bool checklistItemsRefs,
        bool notesRefs,
      })
    >;
typedef $$StatusHistoryTableCreateCompanionBuilder =
    StatusHistoryCompanion Function({
      Value<int> id,
      required int applicationId,
      Value<ApplicationStatus?> fromStatus,
      required ApplicationStatus toStatus,
      required DateTime changedAt,
    });
typedef $$StatusHistoryTableUpdateCompanionBuilder =
    StatusHistoryCompanion Function({
      Value<int> id,
      Value<int> applicationId,
      Value<ApplicationStatus?> fromStatus,
      Value<ApplicationStatus> toStatus,
      Value<DateTime> changedAt,
    });

final class $$StatusHistoryTableReferences
    extends
        BaseReferences<_$AppDatabase, $StatusHistoryTable, StatusHistoryRow> {
  $$StatusHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ApplicationsTable _applicationIdTable(_$AppDatabase db) => db
      .applications
      .createAlias('status_history__application_id__applications__id');

  $$ApplicationsTableProcessedTableManager get applicationId {
    final $_column = $_itemColumn<int>('application_id')!;

    final manager = $$ApplicationsTableTableManager(
      $_db,
      $_db.applications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_applicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StatusHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $StatusHistoryTable> {
  $$StatusHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ApplicationStatus?, ApplicationStatus, String>
  get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<ApplicationStatus, ApplicationStatus, String>
  get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ApplicationsTableFilterComposer get applicationId {
    final $$ApplicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.applicationId,
      referencedTable: $db.applications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationsTableFilterComposer(
            $db: $db,
            $table: $db.applications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StatusHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $StatusHistoryTable> {
  $$StatusHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromStatus => $composableBuilder(
    column: $table.fromStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toStatus => $composableBuilder(
    column: $table.toStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
    column: $table.changedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ApplicationsTableOrderingComposer get applicationId {
    final $$ApplicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.applicationId,
      referencedTable: $db.applications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationsTableOrderingComposer(
            $db: $db,
            $table: $db.applications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StatusHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $StatusHistoryTable> {
  $$StatusHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ApplicationStatus?, String> get fromStatus =>
      $composableBuilder(
        column: $table.fromStatus,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<ApplicationStatus, String> get toStatus =>
      $composableBuilder(column: $table.toStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  $$ApplicationsTableAnnotationComposer get applicationId {
    final $$ApplicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.applicationId,
      referencedTable: $db.applications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.applications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StatusHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StatusHistoryTable,
          StatusHistoryRow,
          $$StatusHistoryTableFilterComposer,
          $$StatusHistoryTableOrderingComposer,
          $$StatusHistoryTableAnnotationComposer,
          $$StatusHistoryTableCreateCompanionBuilder,
          $$StatusHistoryTableUpdateCompanionBuilder,
          (StatusHistoryRow, $$StatusHistoryTableReferences),
          StatusHistoryRow,
          PrefetchHooks Function({bool applicationId})
        > {
  $$StatusHistoryTableTableManager(_$AppDatabase db, $StatusHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StatusHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StatusHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StatusHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> applicationId = const Value.absent(),
                Value<ApplicationStatus?> fromStatus = const Value.absent(),
                Value<ApplicationStatus> toStatus = const Value.absent(),
                Value<DateTime> changedAt = const Value.absent(),
              }) => StatusHistoryCompanion(
                id: id,
                applicationId: applicationId,
                fromStatus: fromStatus,
                toStatus: toStatus,
                changedAt: changedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int applicationId,
                Value<ApplicationStatus?> fromStatus = const Value.absent(),
                required ApplicationStatus toStatus,
                required DateTime changedAt,
              }) => StatusHistoryCompanion.insert(
                id: id,
                applicationId: applicationId,
                fromStatus: fromStatus,
                toStatus: toStatus,
                changedAt: changedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StatusHistoryTable, StatusHistoryRow>(table),
                  $$StatusHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({applicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (applicationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.applicationId,
                        referencedTable: $$StatusHistoryTableReferences
                            ._applicationIdTable(db),
                        referencedColumn: $$StatusHistoryTableReferences
                            ._applicationIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StatusHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StatusHistoryTable,
      StatusHistoryRow,
      $$StatusHistoryTableFilterComposer,
      $$StatusHistoryTableOrderingComposer,
      $$StatusHistoryTableAnnotationComposer,
      $$StatusHistoryTableCreateCompanionBuilder,
      $$StatusHistoryTableUpdateCompanionBuilder,
      (StatusHistoryRow, $$StatusHistoryTableReferences),
      StatusHistoryRow,
      PrefetchHooks Function({bool applicationId})
    >;
typedef $$InterviewsTableCreateCompanionBuilder = InterviewsCompanion Function({
  Value<int> id,
  required int applicationId,
  required String title,
  required InterviewFormat format,
  required DateTime scheduledAt,
  Value<int?> durationMinutes,
  Value<String?> location,
  Value<String?> interviewer,
  Value<InterviewOutcome> outcome,
  Value<String?> summary,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$InterviewsTableUpdateCompanionBuilder = InterviewsCompanion Function({
  Value<int> id,
  Value<int> applicationId,
  Value<String> title,
  Value<InterviewFormat> format,
  Value<DateTime> scheduledAt,
  Value<int?> durationMinutes,
  Value<String?> location,
  Value<String?> interviewer,
  Value<InterviewOutcome> outcome,
  Value<String?> summary,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$InterviewsTableReferences
    extends BaseReferences<_$AppDatabase, $InterviewsTable, InterviewRow> {
  $$InterviewsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ApplicationsTable _applicationIdTable(_$AppDatabase db) => db
      .applications
      .createAlias('interviews__application_id__applications__id');

  $$ApplicationsTableProcessedTableManager get applicationId {
    final $_column = $_itemColumn<int>('application_id')!;

    final manager = $$ApplicationsTableTableManager(
      $_db,
      $_db.applications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_applicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ChecklistItemsTable, List<ChecklistItemRow>>
  _checklistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.checklistItems,
    aliasName: 'interviews__id__checklist_items__interview_id',
  );

  $$ChecklistItemsTableProcessedTableManager get checklistItemsRefs {
    final manager = $$ChecklistItemsTableTableManager(
      $_db,
      $_db.checklistItems,
    ).filter((f) => f.interviewId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_checklistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InterviewsTableFilterComposer
    extends Composer<_$AppDatabase, $InterviewsTable> {
  $$InterviewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InterviewFormat, InterviewFormat, String>
  get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get interviewer => $composableBuilder(
    column: $table.interviewer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InterviewOutcome, InterviewOutcome, String>
  get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ApplicationsTableFilterComposer get applicationId {
    final $$ApplicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.applicationId,
      referencedTable: $db.applications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationsTableFilterComposer(
            $db: $db,
            $table: $db.applications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> checklistItemsRefs(
    Expression<bool> Function($$ChecklistItemsTableFilterComposer f) f,
  ) {
    final $$ChecklistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.interviewId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableFilterComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InterviewsTableOrderingComposer
    extends Composer<_$AppDatabase, $InterviewsTable> {
  $$InterviewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interviewer => $composableBuilder(
    column: $table.interviewer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ApplicationsTableOrderingComposer get applicationId {
    final $$ApplicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.applicationId,
      referencedTable: $db.applications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationsTableOrderingComposer(
            $db: $db,
            $table: $db.applications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InterviewsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InterviewsTable> {
  $$InterviewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InterviewFormat, String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get interviewer => $composableBuilder(
    column: $table.interviewer,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<InterviewOutcome, String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ApplicationsTableAnnotationComposer get applicationId {
    final $$ApplicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.applicationId,
      referencedTable: $db.applications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.applications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> checklistItemsRefs<T extends Object>(
    Expression<T> Function($$ChecklistItemsTableAnnotationComposer a) f,
  ) {
    final $$ChecklistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklistItems,
      getReferencedColumn: (t) => t.interviewId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.checklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InterviewsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InterviewsTable,
          InterviewRow,
          $$InterviewsTableFilterComposer,
          $$InterviewsTableOrderingComposer,
          $$InterviewsTableAnnotationComposer,
          $$InterviewsTableCreateCompanionBuilder,
          $$InterviewsTableUpdateCompanionBuilder,
          (InterviewRow, $$InterviewsTableReferences),
          InterviewRow,
          PrefetchHooks Function({bool applicationId, bool checklistItemsRefs})
        > {
  $$InterviewsTableTableManager(_$AppDatabase db, $InterviewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InterviewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InterviewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InterviewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> applicationId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<InterviewFormat> format = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<int?> durationMinutes = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> interviewer = const Value.absent(),
                Value<InterviewOutcome> outcome = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => InterviewsCompanion(
                id: id,
                applicationId: applicationId,
                title: title,
                format: format,
                scheduledAt: scheduledAt,
                durationMinutes: durationMinutes,
                location: location,
                interviewer: interviewer,
                outcome: outcome,
                summary: summary,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int applicationId,
                required String title,
                required InterviewFormat format,
                required DateTime scheduledAt,
                Value<int?> durationMinutes = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> interviewer = const Value.absent(),
                Value<InterviewOutcome> outcome = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => InterviewsCompanion.insert(
                id: id,
                applicationId: applicationId,
                title: title,
                format: format,
                scheduledAt: scheduledAt,
                durationMinutes: durationMinutes,
                location: location,
                interviewer: interviewer,
                outcome: outcome,
                summary: summary,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InterviewsTable, InterviewRow>(table),
                  $$InterviewsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({applicationId = false, checklistItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (checklistItemsRefs) db.checklistItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (applicationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.applicationId,
                            referencedTable: $$InterviewsTableReferences
                                ._applicationIdTable(db),
                            referencedColumn: $$InterviewsTableReferences
                                ._applicationIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (checklistItemsRefs)
                        await $_getPrefetchedData<
                          InterviewRow,
                          $InterviewsTable,
                          ChecklistItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$InterviewsTableReferences
                              ._checklistItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InterviewsTableReferences(
                                db,
                                table,
                                p0,
                              ).checklistItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.interviewId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InterviewsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InterviewsTable,
      InterviewRow,
      $$InterviewsTableFilterComposer,
      $$InterviewsTableOrderingComposer,
      $$InterviewsTableAnnotationComposer,
      $$InterviewsTableCreateCompanionBuilder,
      $$InterviewsTableUpdateCompanionBuilder,
      (InterviewRow, $$InterviewsTableReferences),
      InterviewRow,
      PrefetchHooks Function({bool applicationId, bool checklistItemsRefs})
    >;
typedef $$ChecklistItemsTableCreateCompanionBuilder =
    ChecklistItemsCompanion Function({
      Value<int> id,
      required int applicationId,
      Value<int?> interviewId,
      required String title,
      Value<bool> isDone,
      required int position,
      Value<DateTime?> completedAt,
      required DateTime createdAt,
    });
typedef $$ChecklistItemsTableUpdateCompanionBuilder =
    ChecklistItemsCompanion Function({
      Value<int> id,
      Value<int> applicationId,
      Value<int?> interviewId,
      Value<String> title,
      Value<bool> isDone,
      Value<int> position,
      Value<DateTime?> completedAt,
      Value<DateTime> createdAt,
    });

final class $$ChecklistItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ChecklistItemsTable, ChecklistItemRow> {
  $$ChecklistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ApplicationsTable _applicationIdTable(_$AppDatabase db) => db
      .applications
      .createAlias('checklist_items__application_id__applications__id');

  $$ApplicationsTableProcessedTableManager get applicationId {
    final $_column = $_itemColumn<int>('application_id')!;

    final manager = $$ApplicationsTableTableManager(
      $_db,
      $_db.applications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_applicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InterviewsTable _interviewIdTable(_$AppDatabase db) => db.interviews
      .createAlias('checklist_items__interview_id__interviews__id');

  $$InterviewsTableProcessedTableManager? get interviewId {
    final $_column = $_itemColumn<int>('interview_id');
    if ($_column == null) return null;
    final manager = $$InterviewsTableTableManager(
      $_db,
      $_db.interviews,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_interviewIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChecklistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ApplicationsTableFilterComposer get applicationId {
    final $$ApplicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.applicationId,
      referencedTable: $db.applications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationsTableFilterComposer(
            $db: $db,
            $table: $db.applications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InterviewsTableFilterComposer get interviewId {
    final $$InterviewsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.interviewId,
      referencedTable: $db.interviews,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterviewsTableFilterComposer(
            $db: $db,
            $table: $db.interviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDone => $composableBuilder(
    column: $table.isDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ApplicationsTableOrderingComposer get applicationId {
    final $$ApplicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.applicationId,
      referencedTable: $db.applications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationsTableOrderingComposer(
            $db: $db,
            $table: $db.applications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InterviewsTableOrderingComposer get interviewId {
    final $$InterviewsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.interviewId,
      referencedTable: $db.interviews,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterviewsTableOrderingComposer(
            $db: $db,
            $table: $db.interviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ApplicationsTableAnnotationComposer get applicationId {
    final $$ApplicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.applicationId,
      referencedTable: $db.applications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.applications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InterviewsTableAnnotationComposer get interviewId {
    final $$InterviewsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.interviewId,
      referencedTable: $db.interviews,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterviewsTableAnnotationComposer(
            $db: $db,
            $table: $db.interviews,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChecklistItemsTable,
          ChecklistItemRow,
          $$ChecklistItemsTableFilterComposer,
          $$ChecklistItemsTableOrderingComposer,
          $$ChecklistItemsTableAnnotationComposer,
          $$ChecklistItemsTableCreateCompanionBuilder,
          $$ChecklistItemsTableUpdateCompanionBuilder,
          (ChecklistItemRow, $$ChecklistItemsTableReferences),
          ChecklistItemRow,
          PrefetchHooks Function({bool applicationId, bool interviewId})
        > {
  $$ChecklistItemsTableTableManager(
    _$AppDatabase db,
    $ChecklistItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> applicationId = const Value.absent(),
                Value<int?> interviewId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> isDone = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ChecklistItemsCompanion(
                id: id,
                applicationId: applicationId,
                interviewId: interviewId,
                title: title,
                isDone: isDone,
                position: position,
                completedAt: completedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int applicationId,
                Value<int?> interviewId = const Value.absent(),
                required String title,
                Value<bool> isDone = const Value.absent(),
                required int position,
                Value<DateTime?> completedAt = const Value.absent(),
                required DateTime createdAt,
              }) => ChecklistItemsCompanion.insert(
                id: id,
                applicationId: applicationId,
                interviewId: interviewId,
                title: title,
                isDone: isDone,
                position: position,
                completedAt: completedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChecklistItemsTable, ChecklistItemRow>(table),
                  $$ChecklistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({applicationId = false, interviewId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (applicationId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.applicationId,
                            referencedTable: $$ChecklistItemsTableReferences
                                ._applicationIdTable(db),
                            referencedColumn: $$ChecklistItemsTableReferences
                                ._applicationIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (interviewId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.interviewId,
                            referencedTable: $$ChecklistItemsTableReferences
                                ._interviewIdTable(db),
                            referencedColumn: $$ChecklistItemsTableReferences
                                ._interviewIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ChecklistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChecklistItemsTable,
      ChecklistItemRow,
      $$ChecklistItemsTableFilterComposer,
      $$ChecklistItemsTableOrderingComposer,
      $$ChecklistItemsTableAnnotationComposer,
      $$ChecklistItemsTableCreateCompanionBuilder,
      $$ChecklistItemsTableUpdateCompanionBuilder,
      (ChecklistItemRow, $$ChecklistItemsTableReferences),
      ChecklistItemRow,
      PrefetchHooks Function({bool applicationId, bool interviewId})
    >;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  Value<int> id,
  required int applicationId,
  required String content,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<int> id,
  Value<int> applicationId,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, NoteRow> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ApplicationsTable _applicationIdTable(_$AppDatabase db) =>
      db.applications.createAlias('notes__application_id__applications__id');

  $$ApplicationsTableProcessedTableManager get applicationId {
    final $_column = $_itemColumn<int>('application_id')!;

    final manager = $$ApplicationsTableTableManager(
      $_db,
      $_db.applications,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_applicationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ApplicationsTableFilterComposer get applicationId {
    final $$ApplicationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.applicationId,
      referencedTable: $db.applications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationsTableFilterComposer(
            $db: $db,
            $table: $db.applications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ApplicationsTableOrderingComposer get applicationId {
    final $$ApplicationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.applicationId,
      referencedTable: $db.applications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationsTableOrderingComposer(
            $db: $db,
            $table: $db.applications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ApplicationsTableAnnotationComposer get applicationId {
    final $$ApplicationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.applicationId,
      referencedTable: $db.applications,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationsTableAnnotationComposer(
            $db: $db,
            $table: $db.applications,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          NoteRow,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (NoteRow, $$NotesTableReferences),
          NoteRow,
          PrefetchHooks Function({bool applicationId})
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> applicationId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                applicationId: applicationId,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int applicationId,
                required String content,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => NotesCompanion.insert(
                id: id,
                applicationId: applicationId,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NotesTable, NoteRow>(table),
                  $$NotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({applicationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (applicationId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.applicationId,
                        referencedTable: $$NotesTableReferences
                            ._applicationIdTable(db),
                        referencedColumn: $$NotesTableReferences
                            ._applicationIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      NoteRow,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (NoteRow, $$NotesTableReferences),
      NoteRow,
      PrefetchHooks Function({bool applicationId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ApplicationsTableTableManager get applications =>
      $$ApplicationsTableTableManager(_db, _db.applications);
  $$StatusHistoryTableTableManager get statusHistory =>
      $$StatusHistoryTableTableManager(_db, _db.statusHistory);
  $$InterviewsTableTableManager get interviews =>
      $$InterviewsTableTableManager(_db, _db.interviews);
  $$ChecklistItemsTableTableManager get checklistItems =>
      $$ChecklistItemsTableTableManager(_db, _db.checklistItems);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
}
