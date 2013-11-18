---
layout: post
title: JComboBoxを使ってポップアップメニューをスクロール
category: swing
folder: BasicComboPopup
tags: [BasicComboPopup, JTextPane, JComboBox]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2005-10-17

## JComboBoxを使ってポップアップメニューをスクロール
`JComboBox`を使ってスクロール可能なポップアップメニューを表示します。

{% download %}

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTH_tpIbsI/AAAAAAAAASE/DrHgihVbnn0/s800/BasicComboPopup.png)

### サンプルコード
<pre class="prettyprint"><code>JComboBox combo = new JComboBox(strArray);
BasicComboPopup popup = new BasicComboPopup(combo) {
  @Override public boolean isFocusable() {
    return true;
  }
  private MouseAdapter listener = null;
  @Override protected void installListListeners() {
    super.installListListeners();
    listener = new MouseAdapter() {
      @Override public void mouseClicked(MouseEvent e) {
        hide();
        System.out.println(comboBox.getSelectedItem());
        append((String)combo.getSelectedItem());
      }
    };
    if(listener!=null) {
      list.addMouseListener(listener);
    }
  }
  @Override public void uninstallingUI() {
    if(listener != null) {
      list.removeMouseListener(listener);
      listener = null;
    }
    super.uninstallingUI();
  }
};
</code></pre>

### 解説
上記のサンプルでは、<kbd>Shift+Tab</kbd>でポップアップメニューが表示され、<kbd>Up</kbd>, <kbd>Down</kbd>キーで移動、<kbd>Enter</kbd>で`JTextPane`のカーソルの後に選択された文字列が入力されます。

コンボボックスのポップアップ部分の`UI`を表現する`BasicComboPopup`を利用することで、スクロールバーをもつポップアップメニューを実現しています。

フォースを取得して、キー入力で選択を変更できるように、`BasicComboPopup#isFocusable`メソッドをオーバーライドしています。また、`BasicComboPopup#show`したあと、`BasicComboPopup#requestFocusInWindow`する必要があります。

- - - -
`JFrame`から、ポップアップメニューがはみ出す(親`Window`が`HeavyWeightWindow`になる)場合、カーソルキーなどで、アイテムが移動選択できないバグがあったので、`SwingUtilities.getWindowAncestor(popup).toFront();`を追加するなどの修正(`Ubuntu`ではうまく動作しない？)をしました。

<pre class="prettyprint"><code>private void popupMenu(ActionEvent e) {
  Rectangle rect = getMyPopupRect();
  popup.show(jtp, rect.x, rect.y + rect.height);
  EventQueue.invokeLater(new Runnable() {
    @Override public void run() {
      SwingUtilities.getWindowAncestor(popup).toFront();
      popup.requestFocusInWindow();
    }
  });
}
</code></pre>
![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTICNIyr1I/AAAAAAAAASI/CorNUGA0pF8/s800/BasicComboPopup1.png)

- ~~ただし、バージョン(`6uN`？)、`Web Start`などで実行すると、`AccessControlException`が発生します。~~

<!-- dummy comment line for breaking list -->

	Exception in thread "AWT-EventQueue-0" java.security.AccessControlException: access denied (java.awt.AWTPermission setWindowAlwaysOnTop)

- 上記の`AccessControlException`は、`6u10 build b26`で修正されている
    - [Bug ID: 6675802 Regression: heavyweight popups cause SecurityExceptions in applets](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6675802)

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Swing - Scrollable PopupMenu](https://forums.oracle.com/thread/1367473)

<!-- dummy comment line for breaking list -->

### コメント
- 大変参考になりました。その上、マウスクリックで文字列を選定できるようにしたいですが、どうすればいかがですか？ -- [java](http://terai.xrea.jp/java.html) 2008-01-08 (火) 16:25:30
    - どうもです。とりあえず(以前は、マウスクリックでも動作していたと思うのですが、勘違いだったのかも…？)、手抜きですが、`BasicComboPopup#installListListeners`メソッドをオーバーライドしてマウスリスナーを追加してみました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-01-08 (火) 18:23:22
- 助かりました！感動です！ご回答ありがとうございました。 -- [java](http://terai.xrea.jp/java.html) 2008-01-10 (木) 17:38:04
- こんにちは。いつもこのサイトを参考にさせていただいています。ようやく自分の`java`アプリケーションをリリースしました（[http://www.jdbckit.com](http://www.jdbckit.com)  まだ更新中ですが、）。次回のバージョンアップで、`Special Thanks`をバージョン情報画面に設けて、Terai Atsuhiro様のサイトを感謝対象にさせてよろしいでしょうか？ -- [java](http://terai.xrea.jp/java.html) 2008-02-22 (金) 15:13:04
    - こんばんは。どうもです。おお、おめでとうございます。リンクの件はご自由にどうぞ。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-02-22 (金) 17:00:18
    - 余談: ドキュメントに何か書く必要があるのって、`Apache Software License`でしたっけ？基本的(引用先を強調している`Tips`を除く)に、このサイトの`Tips`は、ちいさなサンプルを目指しているため、コピペしても単独ではあまり役に立たないものが多く、完全に無保証なので、ライセンスなどは気しなくても良いです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-02-22 (金) 17:01:08

<!-- dummy comment line for breaking list -->

