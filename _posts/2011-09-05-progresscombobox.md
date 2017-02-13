---
layout: post
category: swing
folder: ProgressComboBox
title: JComboBox内にJProgressBarを表示
tags: [JComboBox, ListCellRenderer, JProgressBar, SwingWorker]
author: aterai
pubdate: 2011-09-05T17:17:06+09:00
description: JComboBox内にJProgressBarを設定して進捗を表示します。
image: https://lh6.googleusercontent.com/-wtOABuv6qdQ/TmR3t1oq-qI/AAAAAAAABBg/jbHLwwMR1gc/s800/ProgressComboBox.png
hreflang:
    href: http://java-swing-tips.blogspot.com/2011/09/jprogressbar-in-jcombobox.html
    lang: en
comments: true
---
## 概要
`JComboBox`内に`JProgressBar`を設定して進捗を表示します。

{% download https://lh6.googleusercontent.com/-wtOABuv6qdQ/TmR3t1oq-qI/AAAAAAAABBg/jbHLwwMR1gc/s800/ProgressComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>class ProgressCellRenderer extends DefaultListCellRenderer {
  private final JProgressBar bar = new JProgressBar() {
    @Override public Dimension getPreferredSize() {
      return ProgressCellRenderer.this.getPreferredSize();
    }
  };
  @Override public Component getListCellRendererComponent(
      JList list, Object value, int index,
      boolean isSelected, boolean cellHasFocus) {
    if (index &lt; 0 &amp;&amp; worker != null &amp;&amp; !worker.isDone()) {
      bar.setFont(list.getFont());
      bar.setBorder(BorderFactory.createEmptyBorder(0, 0, 0, 0));
      bar.setValue(count);
      return bar;
    } else {
      return super.getListCellRendererComponent(
        list, value, index, isSelected, cellHasFocus);
    }
  }
  @Override public void updateUI() {
    super.updateUI();
    if (bar != null) {
      SwingUtilities.updateComponentTreeUI(bar);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、`index`が`-1`(アイテムリストのインデックスではない)の場合、`JProgressBar`を返すセルレンダラーを`JComboBox`に設定して進捗を表示しています。

- - - -
ロードボタンが押されたら、以下のような`SwingWorker`で、`JComboBox`にアイテムを追加しています。

<pre class="prettyprint"><code>button = new JButton(new AbstractAction("load") {
  @Override public void actionPerformed(ActionEvent e) {
    button.setEnabled(false);
    combo.setEnabled(false);
    combo.removeAllItems();
    worker = new SwingWorker&lt;String, String&gt;() {
      private int max = 30;
      @Override public String doInBackground() {
        int current = 0;
        while (current &lt;= max &amp;&amp; !isCancelled()) {
          try {
            Thread.sleep(50);
            //setProgress(100 * current / max);
            count = 100 * current / max;
            publish("test: "+current);
          } catch (Exception ie) {
            return "Exception";
          }
          current++;
        }
        return "Done";
      }
      @Override protected void process(List&lt;String&gt; chunks) {
        DefaultComboBoxModel m = (DefaultComboBoxModel) combo.getModel();
        for (String s: chunks) {
          m.addElement(s);
        }
        combo.setSelectedIndex(-1);
        combo.repaint();
      }
      @Override public void done() {
        String text = null;
        if (!isCancelled()) {
          combo.setSelectedIndex(0);
        }
        combo.setEnabled(true);
        button.setEnabled(true);
        count = 0;
      }
    };
    worker.execute();
  }
});
</code></pre>

## コメント
