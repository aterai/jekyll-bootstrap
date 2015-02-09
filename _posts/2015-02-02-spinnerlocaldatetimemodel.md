---
layout: post
category: swing
folder: SpinnerLocalDateTimeModel
title: JSpinnerでLocalDateTimeを使用する
tags: [JSpinner, SpinnerModel, LocalDateTime]
author: aterai
pubdate: 2015-02-02T00:12:04+09:00
description: DateやCalendarなどを使用するSpinnerDateModelの代わりに、JDK 8で導入されたLocalDateTimeなどを使用するSpinnerModelを作成して、JSpinnerで日付を選択します。
comments: true
---
## 概要
`Date`や`Calendar`などを使用する`SpinnerDateModel`の代わりに、`JDK 8`で導入された`LocalDateTime`などを使用する`SpinnerModel`を作成して、`JSpinner`で日付を選択します。

{% download https://lh4.googleusercontent.com/-eqirUqK4YWc/VM4--ZB0j_I/AAAAAAAANwI/rsoFU67UgI8/s800/SpinnerLocalDateTimeModel.png %}

## サンプルコード
<pre class="prettyprint"><code>class SpinnerLocalDateTimeModel extends AbstractSpinnerModel {
  private Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; start, end;
  private LocalDateTime value;
  private TemporalUnit temporalUnit;

  public SpinnerLocalDateTimeModel(
      LocalDateTime value, Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; start,
      Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; end, TemporalUnit temporalUnit) {
    super();
    if (value == null) {
      throw new IllegalArgumentException("value is null");
    }
    if (!(start == null || start.compareTo(value) &lt;= 0)
        &amp;&amp; (end == null || end.compareTo(value) &gt;= 0)) {
      throw new IllegalArgumentException("(start &lt;= value &lt;= end) is false");
    }
    this.value = value;
    this.start = start;
    this.end = end;
    this.temporalUnit = temporalUnit;
  }

  public void setStart(Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; start) {
    if (start == null ? this.start != null : !start.equals(this.start)) {
      this.start = start;
      fireStateChanged();
    }
  }

  public Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; getStart() {
    return start;
  }

  public void setEnd(Comparable&lt;ChronoLocalDateTime&lt;?&gt;&gt; end) {
    if (end == null ? this.end != null : !end.equals(this.end)) {
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
    LocalDateTime next = value.plus(1, temporalUnit);
    return end == null || end.compareTo(next) &gt;= 0 ? next : null;
  }

  @Override public Object getPreviousValue() {
    //Calendar cal = Calendar.getInstance();
    //cal.setTime(value.getTime());
    //cal.add(calendarField, -1);
    //Date prev = cal.getTime();
    LocalDateTime prev = value.minus(1, temporalUnit);
    return start == null || start.compareTo(prev) &lt;= 0 ? prev : null;
  }

  public LocalDateTime getLocalDateTime() {
    return value;
  }

  @Override public Object getValue() {
    return value;
  }

  @Override public void setValue(Object value) {
    if (!(value instanceof LocalDateTime)) {
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
    - * 参考リンク [#jd46cbda]
- [JSpinnerで日付を設定](http://ateraimemo.com/Swing/SpinnerDateModel.html)

<!-- dummy comment line for breaking list -->

## コメント
