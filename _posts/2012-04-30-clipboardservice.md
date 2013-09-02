---
layout: post
title: ClipboardServiceでシステム全体の共有クリップボードにアクセスする
category: swing
folder: ClipboardService
tags: [ServiceManager, ClipboardService, JTextComponent]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2012-04-30

## ClipboardServiceでシステム全体の共有クリップボードにアクセスする
`ClipboardService`を使って`Java Web Start`で動作中のアプリケーションからシステム全体の共有クリップボードにアクセスします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh5.googleusercontent.com/--_lXbzG-H7g/T53noZrOnHI/AAAAAAAABME/FyY8MKdHSg0/s800/ClipboardService.png)

### サンプルコード
<pre class="prettyprint"><code>private ClipboardService cs;
</code></pre>

<pre class="prettyprint"><code>try{
  cs = (ClipboardService)ServiceManager.lookup("javax.jnlp.ClipboardService");
}catch(Throwable t) {
  cs = null;
}
JTextArea textArea = new JTextArea() {
  @Override public void copy() {
    if(cs != null) {
      cs.setContents(new StringSelection(getSelectedText()));
    }
    super.copy();
  }
  @Override public void cut() {
    if(cs != null) {
      cs.setContents(new StringSelection(getSelectedText()));
    }
    super.cut();
  }
  @Override public void paste() {
    if(cs != null) {
      Transferable tr = cs.getContents();
      if(tr.isDataFlavorSupported(DataFlavor.stringFlavor)) {
        try{
          getTransferHandler().importData(this, tr);
        }catch(Exception e) {
          e.printStackTrace();
        }
      }
    }else{
      super.paste();
    }
  }
};
</code></pre>

### 解説
`Java Web Start`から起動された制限付きのランタイム内で動作中するアプリケーションからは、システム全体の共有クリップボードにアクセスすることができないので、`ServiceManager`から`ClipboardService`を取得し、コピー、ペースト、カットなどでセキュリティ警告ダイアログを表示して、ユーザーにアクセス許可を求めます。

- カットの例
    - アプリケーションのクリップボード
        - セキュリティ警告でＯＫ、取り消しのどちらを選択しても、`JTextArea`の選択文字列はカットされ、アプリケーションのクリップボードは上書きされる
    - システム全体の共有クリップボード
    - セキュリティ警告でＯＫを選択するとシステム全体の共有クリップボードは上書きされ、取り消しを選択すると上書きされない

<!-- dummy comment line for breaking list -->

### 参考リンク
- [ClipboardService サービスの使い方 - JNLP API の使用例](http://docs.oracle.com/javase/jp/6/technotes/guides/javaws/developersguide/examples.html#ClipboardService)
- [Java Web Start 開発者ガイド](http://docs.oracle.com/javase/jp/6/technotes/guides/javaws/developersguide/contents.html)

<!-- dummy comment line for breaking list -->

### コメント
