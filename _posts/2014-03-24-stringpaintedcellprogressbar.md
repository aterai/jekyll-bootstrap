---
layout: post
category: swing
folder: StringPaintedCellProgressBar
title: TableCellRendererに進捗文字列を設定したJProgressBarを使用する
tags: [JTable, JProgressBar, SwingWorker, TableCellRenderer]
author: aterai
pubdate: 2014-03-24T00:27:55+09:00
description: JTableのTableCellRendererとして、進捗文字列を表示するJProgressBarを設定します。
image: https://lh4.googleusercontent.com/-XSMYQI-BTU8/Uy67ZR-E4TI/AAAAAAAACCE/2zdsU6o7iA0/s800/StringPaintedCellProgressBar.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2014/05/jprogressbar-in-jtable-cell-render.html
    lang: en
comments: true
---
## 概要
`JTable`の`TableCellRenderer`として、進捗文字列を表示する`JProgressBar`を設定します。

{% download https://lh4.googleusercontent.com/-XSMYQI-BTU8/Uy67ZR-E4TI/AAAAAAAACCE/2zdsU6o7iA0/s800/StringPaintedCellProgressBar.png %}

## サンプルコード
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
  private final JProgressBar progress = new JProgressBar();
  private final JPanel renderer = new JPanel(new BorderLayout());
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus,
      int row, int column) {
    Component c;
    renderer.removeAll();
    progress.setValue(0);
    if (value instanceof ProgressValue) {
      ProgressValue pv = (ProgressValue) value;
      Integer current = pv.getProgress();
      Integer lengthOfTask = pv.getLengthOfTask();
      if (current &lt; 0) {
        c = super.getTableCellRendererComponent(
            table, "Canceled", isSelected, hasFocus, row, column);
      } else if (current &lt; lengthOfTask) {
        progress.setValue(current * 100 / lengthOfTask);
        progress.setStringPainted(true);
        progress.setString(String.format("%d/%d", current, lengthOfTask));
        renderer.add(progress);
        c = renderer;
      } else {
        c = super.getTableCellRendererComponent(
                table, "Done", isSelected, hasFocus, row, column);
      }
    } else {
      c = super.getTableCellRendererComponent(
              table, "Waiting...", isSelected, hasFocus, row, column);
    }
    return c;
  }

  @Override public void updateUI() {
    super.updateUI();
    setOpaque(true);
    if (Objects.nonNull(renderer)) {
      SwingUtilities.updateComponentTreeUI(renderer);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`2`列目の`TableCellRenderer`として`JProgressBar#setStringPainted(true)`で進捗文字列を表示するように設定した`JProgressBar`を使用しています。

- 進捗状況文字列は「現在値/最大値」の形式で表示するため、この`2`つの値を保持する`ProgressValue`オブジェクトを作成して`SwingWorker#publish(...)`メソッドで`JTable`のモデルに設定
- `TableCellRenderer`はモデルから取得した`ProgressValue`オブジェクトから以下の`3`つの値を`JProgressBar`に設定し、セルの描画用コンポーネントとして使用
    - `JProgressBar#setMaximum(int)`(最大値は、各行ごとにランダムなので)で最大値を設定
    - `JProgressBar#setValue(int)`で現在値を設定
    - 上記の値から生成した進捗状況文字列を`JProgressBar#setString(String)`で設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTableのセルにJProgressBarを表示](https://ateraimemo.com/Swing/TableCellProgressBar.html)

<!-- dummy comment line for breaking list -->

## コメント
