---
layout: post
title: TableCellRendererに進捗文字列を設定したJProgressBarを使用する
category: swing
folder: StringPaintedCellProgressBar
tags: [JTable, JProgressBar, SwingWorker, TableCellRenderer]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2014-03-24

## TableCellRendererに進捗文字列を設定したJProgressBarを使用する
`JTable`の`TableCellRenderer`として、進捗文字列を表示する`JProgressBar`を設定します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/-XSMYQI-BTU8/Uy67ZR-E4TI/AAAAAAAACCE/2zdsU6o7iA0/s800/StringPaintedCellProgressBar.png)

### サンプルコード
<pre class="prettyprint"><code>class Task extends SwingWorker&lt;Integer, ProgressValue&gt; {
  private final int lengthOfTask;
  private final int sleepDummy = new Random().nextInt(100) + 1;
  public Task(int lengthOfTask) {
    super();
    this.lengthOfTask = lengthOfTask;
  }
  @Override protected Integer doInBackground() {
    int current = 0;
    while (current &lt; lengthOfTask &amp;&amp; !isCancelled()) {
      current++;
      try {
        Thread.sleep(sleepDummy);
      } catch (InterruptedException ie) {
        break;
      }
      publish(new ProgressValue(lengthOfTask, current));
    }
    return sleepDummy * lengthOfTask;
  }
}

class ProgressValue {
  private final Integer progress;
  private final Integer lengthOfTask;
  public ProgressValue(Integer lengthOfTask, Integer progress) {
    this.progress = progress;
    this.lengthOfTask = lengthOfTask;
  }
  public Integer getProgress() {
    return progress;
  }
  public Integer getLengthOfTask() {
    return lengthOfTask;
  }
}

class ProgressRenderer extends DefaultTableCellRenderer {
  private final JProgressBar b = new JProgressBar();
  private final JPanel p = new JPanel(new BorderLayout());
  public ProgressRenderer() {
    super();
    setOpaque(true);
    b.setStringPainted(true);
    p.add(b);
  }
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus,
      int row, int column) {
    String text = "Done";
    if (value instanceof ProgressValue) {
      ProgressValue pv = (ProgressValue) value;
      Integer current = pv.getProgress();
      Integer lengthOfTask = pv.getLengthOfTask();
      if (current &lt; 0) {
        text = "Canceled";
      } else if (current &lt; lengthOfTask) {
        b.setMaximum(lengthOfTask);
        b.setValue(current);
        b.setString(String.format("%d/%d", current, lengthOfTask));
        return p;
      }
    }
    super.getTableCellRendererComponent(
        table, text, isSelected, hasFocus, row, column);
    return this;
  }
  @Override public void updateUI() {
    super.updateUI();
    if (p != null) {
      SwingUtilities.updateComponentTreeUI(p);
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、`2`列目の`TableCellRenderer`として、`JProgressBar#setStringPainted(true)`と進捗文字列を表示するように設定した`JProgressBar`を使用しています。進捗状況文字列は、現在値/最大値の形式で表示するため、`SwingWorker#publish(...)`には、この`2`つの値を保持する`ProgressValue`オブジェクトを作成して渡しています。`TableCellRenderer`は、この`ProgressValue`オブジェクトを受け取り、`JProgressBar#setMaximum(int)`(最大値は、各行ごとにランダムなので)、`JProgressBar#setValue(int)`、`JProgressBar#setString(String)`の`3`つを設定した`JProgressBar`をセル描画用コンポーネントとして返しています。

### 参考リンク
- [JTableのセルにJProgressBarを表示](http://terai.xrea.jp/Swing/TableCellProgressBar.html)

<!-- dummy comment line for breaking list -->

### コメント
