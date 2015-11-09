---
layout: post
category: swing
folder: HtmlTableTransferHandler
title: JTableのHTML形式コピーをカスタマイズする
tags: [JTable, TransferHandler, Html]
author: aterai
pubdate: 2014-09-01T00:14:35+09:00
description: JTableのセルを選択してクリップボードにHTMLテキストをコピーするとき、そのセルのクラスに応じて生成するタグを変更します。
comments: true
---
## 概要
`JTable`のセルを選択してクリップボードに`HTML`テキストをコピーするとき、そのセルのクラスに応じて生成するタグを変更します。

{% download https://lh5.googleusercontent.com/-VsQ_pmP_GKM/VAM3IR6IvyI/AAAAAAAACMI/97dngpaAQn8/s800/HtmlTableTransferHandler.png %}

## サンプルコード
<pre class="prettyprint"><code>class HtmlTableTransferHandler extends TransferHandler {
  //@see javax/swing/plaf/basic/
  //     BasicTableUI.TableTransferHandler#createTransferable(JComponent)
  @Override protected Transferable createTransferable(JComponent c) {
    if (c instanceof JTable) {
      JTable table = (JTable) c;
      int[] rows;
      int[] cols;

      if (!table.getRowSelectionAllowed() &amp;&amp; !table.getColumnSelectionAllowed()) {
        return null;
      }

      if (table.getRowSelectionAllowed()) {
        rows = table.getSelectedRows();
      } else {
        int rowCount = table.getRowCount();

        rows = new int[rowCount];
        for (int counter = 0; counter &lt; rowCount; counter++) {
          rows[counter] = counter;
        }
      }

      if (table.getColumnSelectionAllowed()) {
        cols = table.getSelectedColumns();
      } else {
        int colCount = table.getColumnCount();
        cols = new int[colCount];
        for (int counter = 0; counter &lt; colCount; counter++) {
          cols[counter] = counter;
        }
      }

      //if (rows == null || cols == null || rows.length == 0 || cols.length == 0) {
      if (cols == null || rows.length == 0 || cols.length == 0) {
        return null;
      }

      StringBuffer plainBuf = new StringBuffer();
      StringBuffer htmlBuf = new StringBuffer(64);

      htmlBuf.append("&lt;html&gt;\n&lt;body&gt;\n&lt;table border='1'&gt;\n");

      for (int row = 0; row &lt; rows.length; row++) {
        htmlBuf.append("&lt;tr&gt;\n");
        for (int col = 0; col &lt; cols.length; col++) {
          Object obj = table.getValueAt(rows[row], cols[col]);
          String val = Objects.toString(obj, "") + "\t";
            //.replace("&amp;", "&amp;amp;").replace("&lt;", "&amp;lt;").replace("&gt;", "&amp;gt;");
          plainBuf.append(val);

          if (obj instanceof Date) {
            String v = Objects.toString((Date) obj, "");
            htmlBuf.append("  &lt;td&gt;&lt;time&gt;" + v + "&lt;/time&gt;&lt;/td&gt;\n");
          } else  if (obj instanceof Color) {
            htmlBuf.append(String.format(
                "  &lt;td style='background-color:#%06X'&gt;&amp;nbsp;&lt;/td&gt;%n",
                ((Color) obj).getRGB() &amp; 0xffffff));
          } else {
            htmlBuf.append("  &lt;td&gt;" + Objects.toString(obj, "") + "&lt;/td&gt;\n");
          }
        }
        // we want a newline at the end of each line and not a tab
        plainBuf.deleteCharAt(plainBuf.length() - 1).append("\n");
        htmlBuf.append("&lt;/tr&gt;\n");
      }

      // remove the last newline
      plainBuf.deleteCharAt(plainBuf.length() - 1);
      htmlBuf.append("&lt;/table&gt;\n&lt;/body&gt;\n&lt;/html&gt;");

      return new BasicTransferable(plainBuf.toString(), htmlBuf.toString());
    }

    return null;
  }
  @Override public int getSourceActions(JComponent c) {
    return COPY;
  }
}
</code></pre>

## 解説
- 上: デフォルトの`BasicTableUI.TableTransferHandler`を使用
- 下: `HtmlTableTransferHandler`を設定
    - `TransferHandler#createTransferable(JComponent)`をオーバーライドしてクリップボードに渡す`text/html`なテキストを独自に作成
        - `text/plain`は`BasicTableUI.TableTransferHandler`のコピーをそのまま使用
        - `<table>`タグに属性`border='1'`を追加
    - セルのクラスに応じたタグを生成
        - `Date`: `<time>...</time>`で囲む
        - `Color`: `<td>`に`style='background-color:#%06x'>`で背景色を設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Java Swing「ドラッグ&ドロップ」メモ(Hishidama's Swing-TransferHandler Memo)](http://www.ne.jp/asahi/hishidama/home/tech/java/swing/TransferHandler.html)
- [JTableでプロパティ一覧表を作成する](http://ateraimemo.com/Swing/PropertyTable.html)

<!-- dummy comment line for breaking list -->

## コメント
