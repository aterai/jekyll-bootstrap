---
layout: post
category: swing
folder: SpinnerDateModel
title: JSpinnerで日付を設定
tags: [JSpinner, SpinnerDateModel, FocusListener, Calendar]
author: aterai
pubdate: 2011-08-22T15:46:11+09:00
description: JSpinnerに、下限値を設定したSpinnerDateModelを設定して、日付の変更をテストします。
image: https://lh5.googleusercontent.com/-llHXaOVDQbQ/TlH5yRAODSI/AAAAAAAABBE/XsSUtm7J_U0/s800/SpinnerDateModel.png
comments: true
---
## 概要
`JSpinner`に、下限値を設定した`SpinnerDateModel`を設定して、日付の変更をテストします。

{% download https://lh5.googleusercontent.com/-llHXaOVDQbQ/TlH5yRAODSI/AAAAAAAABBE/XsSUtm7J_U0/s800/SpinnerDateModel.png %}

## サンプルコード
<pre class="prettyprint"><code>String dateFormatPattern = "yyyy/MM/dd";
JSpinner s = new JSpinner(
    new SpinnerDateModel(date, start, null, Calendar.DAY_OF_MONTH));
JSpinner.DateEditor editor = new JSpinner.DateEditor(s, dateFormatPattern);
s.setEditor(editor);
editor.getTextField().addFocusListener(new FocusAdapter() {
  @Override public void focusGained(FocusEvent e) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        int i = dateFormatPattern.lastIndexOf("dd");
        editor.getTextField().select(i, i + 2);
      }
    });
  }
});
</code></pre>

## 解説
- `Calendar.DAY_OF_MONTH`
    - 本日を現在の値と下限値、上限値は`null`(制限無し)、増減値を`Calendar.DAY_OF_MONTH`とした`SpinnerDateModel`を使用
        - 下限値が現在時刻(例: `Mon Aug 22 15:09:27 JST 2011`)なので、現在の値(`Mon Aug 22 00:00:00 JST 2011`)が範囲外となり、矢印ボタンで日付を変更できない
        - 参考: [Swing - DateSpinner spins only after an edit](https://community.oracle.com/thread/2268752)

<!-- dummy comment line for breaking list -->

- `min: set(Calendar.HOUR_OF_DAY, 0)`
    - 下限値を以下のように本日の始めにリセット
        - 例: `Mon Aug 22 15:09:27 JST 2011`を`Mon Aug 22 00:00:00 JST 2011`
            
            <pre class="prettyprint"><code>Calendar today = Calendar.getInstance();
            today.clear(Calendar.MILLISECOND);
            today.clear(Calendar.SECOND);
            today.clear(Calendar.MINUTE);
            today.set(Calendar.HOUR_OF_DAY, 0);
            Date start = today.getTime();
            
            System.out.println(date);
            System.out.println(start);
            
            JSpinner spinner2 = new JSpinner(new SpinnerDateModel(
                date, start, null, Calendar.DAY_OF_MONTH));
            spinner2.setEditor(new JSpinner.DateEditor(spinner2, dateFormatPattern));
</code></pre>
- `JSpinner.DateEditor + FocusListener`
    - フォーカスがエディタに移動した場合、日付部分が選択状態になるようリスナーを設定
        - 矢印ボタンのクリックで編集開始した場合、先頭の年度部分ではなく日付が増減する
        - 参考: [CellEditorをJSpinnerにして日付を変更](https://ateraimemo.com/Swing/DateCellEditor.html)

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Swing - DateSpinner spins only after an edit](https://community.oracle.com/thread/2268752)
- [CellEditorをJSpinnerにして日付を変更](https://ateraimemo.com/Swing/DateCellEditor.html)
- [JSpinnerでLocalDateTimeを使用する](https://ateraimemo.com/Swing/SpinnerLocalDateTimeModel.html)
    - `Date`ではなく、`LocalDateTime`を使用する方法

<!-- dummy comment line for breaking list -->


## コメント
