---
layout: post
category: swing
folder: SpinnerLocalDateTimeModel
title: JSpinnerでLocalDateTimeを使用する
tags: [JSpinner, SpinnerModel, LocalDateTime, JFormattedTextField]
author: aterai
pubdate: 2015-02-02T00:12:04+09:00
description: DateやCalendarなどを使用するSpinnerDateModelの代わりに、JDK 8で導入されたLocalDateTimeなどを使用するSpinnerModelを作成して、JSpinnerで日付を選択します。
image: https://lh4.googleusercontent.com/-eqirUqK4YWc/VM4--ZB0j_I/AAAAAAAANwI/rsoFU67UgI8/s800/SpinnerLocalDateTimeModel.png
comments: true
---
## 概要
`Date`や`Calendar`などを使用する`SpinnerDateModel`の代わりに、`JDK 8`で導入された`LocalDateTime`などを使用する`SpinnerModel`を作成して、`JSpinner`で日付を選択します。

{% download https://lh4.googleusercontent.com/-eqirUqK4YWc/VM4--ZB0j_I/AAAAAAAANwI/rsoFU67UgI8/s800/SpinnerLocalDateTimeModel.png %}

## サンプルコード
<pre class="prettyprint"><code>class SpinnerLocalDateTimeModel extends AbstractSpinnerModel implements Serializable {
  private Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; start, end;
  private ChronoLocalDateTime&lt;?&gt; value;
  private TemporalUnit temporalUnit;

  public SpinnerLocalDateTimeModel(
      ChronoLocalDateTime&lt;?&gt; value,
      Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; start,
      Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; end,
      TemporalUnit temporalUnit) {
    super();
    if (Objects.nonNull(start) &amp;&amp; start.compareTo(value) &gt;= 0
     || Objects.nonNull(end)   &amp;&amp; end.compareTo(value)   &lt;= 0) {
      throw new IllegalArgumentException("(start &lt;= value &lt;= end) is false");
    }
    this.value = Optional.ofNullable(value)
                         .orElseThrow(() -&gt; new IllegalArgumentException("value is null"));
    this.start = start;
    this.end = end;
    this.temporalUnit = temporalUnit;
  }

  public void setStart(Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; start) {
    if (Objects.isNull(start) ? Objects.nonNull(this.start)
                              : !Objects.equals(start, this.start)) {
      this.start = start;
      fireStateChanged();
    }
  }

  public Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; getStart() {
    return start;
  }

  public void setEnd(Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; end) {
    if (Objects.isNull(end) ? Objects.nonNull(this.end)
                            : !Objects.equals(end, this.end)) {
      this.end = end;
      fireStateChanged();
    }
  }

  public Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; getEnd() {
    return end;
  }

  public void setTemporalUnit(TemporalUnit temporalUnit) {
    if (temporalUnit != this.temporalUnit) {
      this.temporalUnit = temporalUnit;
      fireStateChanged();
    }
  }

  public TemporalUnit getTemporalUnit() {
    return temporalUnit;
  }

  @Override public Object getNextValue() {
    //Calendar cal = Calendar.getInstance();
    //cal.setTime(value.getTime());
    //cal.add(calendarField, 1);
    //Date next = cal.getTime();
    ChronoLocalDateTime&lt;?&gt; next = value.plus(1, temporalUnit);
    return Objects.isNull(end) || end.compareTo(next) &gt;= 0 ? next : null;
  }

  @Override public Object getPreviousValue() {
    //Calendar cal = Calendar.getInstance();
    //cal.setTime(value.getTime());
    //cal.add(calendarField, -1);
    //Date prev = cal.getTime();
    ChronoLocalDateTime&lt;?&gt; prev = value.minus(1, temporalUnit);
    return Objects.isNull(start) || start.compareTo(prev) &lt;= 0 ? prev : null;
  }

  public ChronoLocalDateTime&lt;?&gt; getLocalDateTime() {
    return value;
  }

  @Override public Object getValue() {
    return value;
  }

  @Override public void setValue(Object value) {
    if (!(value instanceof ChronoLocalDateTime&lt;?&gt;)) {
      throw new IllegalArgumentException("illegal value");
    }
    if (!value.equals(this.value)) {
      this.value = (LocalDateTime) value;
      fireStateChanged();
    }
  }
}
</code></pre>

## 解説
- 上: `SpinnerDateModel`
    - `Calendar`などを使用して開始日、終了日を生成し、`SpinnerDateModel`を作成して、`JSpinner`に設定
        
        <pre class="prettyprint"><code>Calendar cal = Calendar.getInstance();
        cal.clear(Calendar.MILLISECOND);
        cal.clear(Calendar.SECOND);
        cal.clear(Calendar.MINUTE);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        Date date = cal.getTime();
        cal.add(Calendar.DATE, -2);
        Date start = cal.getTime();
        cal.add(Calendar.DATE, 9);
        Date end = cal.getTime();
        JSpinner spinner1 = new JSpinner(new SpinnerDateModel(
            date, start, end, Calendar.DAY_OF_MONTH));
</code></pre>
    - 参考: [JSpinnerで日付を設定](http://ateraimemo.com/Swing/SpinnerDateModel.html)
- 下: `SpinnerLocalDateTimeModel`
    - 内部で、`Date`ではなく、`LocalDateTime`を使用する`SpinnerLocalDateTimeModel`(`AbstractSpinnerModel`を継承)を作成
        
        <pre class="prettyprint"><code>LocalDateTime d = LocalDateTime.now();
        LocalDateTime s = d.minus(2, ChronoUnit.DAYS);
        LocalDateTime e = d.plus(7, ChronoUnit.DAYS);
        JSpinner spinner2 = new JSpinner(new SpinnerLocalDateTimeModel(
            d, s, e, ChronoUnit.DAYS));
</code></pre>
    - スピナエディタも、以下のような`LocalDateTime`を扱うものに変更
        - 参考: [Temporal Spinners « Java Tips Weblog](https://tips4java.wordpress.com/2015/04/09/temporal-spinners/)
            
            <pre class="prettyprint"><code>class LocalDateTimeEditor extends JSpinner.DefaultEditor {
              private final DateTimeFormatter dateTimeFormatter;
              private final SpinnerLocalDateTimeModel model;
            
              public LocalDateTimeEditor(final JSpinner spinner, String dateFormatPattern) {
                super(spinner);
                if (!(spinner.getModel() instanceof SpinnerLocalDateTimeModel)) {
                  throw new IllegalArgumentException("model not a SpinnerLocalDateTimeModel");
                }
                dateTimeFormatter = DateTimeFormatter.ofPattern(dateFormatPattern);
                model = (SpinnerLocalDateTimeModel) spinner.getModel();
                final DefaultFormatter formatter = new LocalDateTimeFormatter();
            
                EventQueue.invokeLater(new Runnable() {
                  @Override public void run() {
                    formatter.setValueClass(LocalDateTime.class);
                    DefaultFormatterFactory factory = new DefaultFormatterFactory(formatter);
                    JFormattedTextField ftf = (JFormattedTextField) getTextField();
                    try {
                      String maxString = formatter.valueToString(model.getStart());
                      String minString = formatter.valueToString(model.getEnd());
                      ftf.setColumns(Math.max(maxString.length(), minString.length()));
                    } catch (ParseException e) {
                      // PENDING: hmuller
                      e.printStackTrace();
                    }
                    ftf.setHorizontalAlignment(JTextField.LEFT);
                    ftf.setEditable(true);
                    ftf.setFormatterFactory(factory);
                  }
                });
              }
            
              public SpinnerLocalDateTimeModel getModel() {
                return (SpinnerLocalDateTimeModel) getSpinner().getModel();
              }
            
              class LocalDateTimeFormatter extends InternationalFormatter {
                public LocalDateTimeFormatter() {
                  super(dateTimeFormatter.toFormat());
                }
                @Override public String valueToString(Object value) throws ParseException {
                  //System.out.println(value.getClass().getName());
                  if (value instanceof TemporalAccessor) {
                    //return ((LocalDateTime) value).format(dateTimeFormatter);
                    return dateTimeFormatter.format((TemporalAccessor) value);
                  } else {
                    return "";
                  }
                }
                @Override public Object stringToValue(String text) throws ParseException {
                  //System.out.println("stringToValue:" + text);
                  try {
                    //LocalDateTime value = LocalDate.parse(text, dateTimeFormatter).atStartOfDay();
                    TemporalAccessor ta = dateTimeFormatter.parse(text);
                    ChronoLocalDateTime&lt;?&gt; value = model.getLocalDateTime();
                    //@see https://tips4java.wordpress.com/2015/04/09/temporal-spinners/
                    for (ChronoField field : ChronoField.values()) {
                      if (field.isSupportedBy(value) &amp;&amp; ta.isSupported(field)) {
                        value = field.adjustInto(value, ta.getLong(field));
                      }
                    }
                    Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; min = model.getStart();
                    Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; max = model.getEnd();
                    if (Objects.nonNull(min) &amp;&amp; min.compareTo(value) &gt; 0
                     || Objects.nonNull(max) &amp;&amp; max.compareTo(value) &lt; 0) {
                      throw new ParseException(text + " is out of range", 0);
                    }
                    return value;
                  } catch (DateTimeParseException e) {
                    ParseException pe = new ParseException(e.getMessage(), e.getErrorIndex());
                    pe.setStackTrace(e.getStackTrace());
                    throw pe;
                  }
                }
              }
            }
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
- [JDK-8169482 java.time.DateTimeFormatter javadoc: F is not week-of-month - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8169482)
- [time - Java 8 DateFormatter week of month and year key symbols difference - Stack Overflow](http://stackoverflow.com/questions/40389916/java-8-dateformatter-week-of-month-and-year-key-symbols-difference)
    - メモ: [DateTimeFormatter](http://docs.oracle.com/javase/jp/8/docs/api/java/time/format/DateTimeFormatter.html#patterns)のパターン文字で、`W`と`F`の説明が両方`week-of-month`になっている
    - 実際は`F`が`day_of_week_in_month`で、`JDK 1.9.0`ではドキュメントが修正されている
- `day_of_week_in_month`について
    - [ChronoField#ALIGNED_DAY_OF_WEEK_IN_MONTH (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/time/temporal/ChronoField.html#ALIGNED_DAY_OF_WEEK_IN_MONTH)
    
    		たとえば、7日からなる週を使用する暦体系では、最初の「位置合せされた月の週番号」は「月の日」1から始まり、2番目の「位置合せされた月の週番号」は「月の日」8から始まる、というようになります。これらの位置合せされた各週に含まれる日に1から7までの番号が付けられ、このフィールドの値として返されます。したがって、「月の日」1から7では、「位置合せされた曜日」の値は1から7になります。また、「月の日」8から14でもこれが繰り返され、「位置合せされた曜日」の値は1から7になります。
    - `F`(`day_of_week_in_month`)は、`1`～`7`の数値文字列に変換される
    - 例えば月の第一日が日曜日の場合、その月の日曜日は`1`、月曜日は`2`、～、土曜日は`7`となる
        - `2017-01-10`(火)は、`2017-01-01`が日曜なので、`3`に変換される
        - `DateTimeFormatter.ofPattern("F").format(LocalDate.of(2017, Month.JANUARY, 10))`は文字列の`3`を返す

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSpinnerで日付を設定](http://ateraimemo.com/Swing/SpinnerDateModel.html)
- [Temporal Spinners « Java Tips Weblog](https://tips4java.wordpress.com/2015/04/09/temporal-spinners/)

<!-- dummy comment line for breaking list -->

## コメント
